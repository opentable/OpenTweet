//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Combine
import UIKit

final class TimelineViewController: UITableViewController {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Tweet>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Tweet>
    
    private lazy var dataSource: DataSource = makeDataSource()

    private lazy var viewModel: TimelineViewModel = TimelineViewModelImpl()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - View Lifecycle
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        title = "Open Tweet"
        tableView.register(TimelineTableViewCell.self, forCellReuseIdentifier: "\(TimelineTableViewCell.self)")
        
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        tableView.addInteraction(contextMenuInteraction)
        
        viewModel.tweetsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tweets in
                self?.applySnapshot(tweets: tweets, animatingDiff: true)
            }
            .store(in: &subscriptions)
        
        viewModel.fetchData()
	}

    // MARK: - Functions
    
    private func makeDataSource() -> DataSource {
        let ds = DataSource(
            tableView: tableView) { [weak self] tableView, indexPath, tweet in
                let cell = tableView.dequeueReusableCell(withIdentifier: "\(TimelineTableViewCell.self)", for: indexPath) as? TimelineTableViewCell
                
                // If the tweet instance has no image data, the ViewModel will try to retrieve the data
                // and update the cell associated with that tweet once the data is fetched.
                // This avoids reloading the whole table when there is an update on the data model(s).
                Task {
                    if tweet.avatarData == nil {
                        if let _ = await self?.viewModel.retrieveAvatar(in: tweet) {
                            self?.update(tweet: tweet, animatingDiff: true)
                        }
                    }
                }

                cell?.tweet = tweet
                return cell
            }
    
        return ds
    }
    
    private func applySnapshot(tweets: [Tweet], animatingDiff: Bool = false) {
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(tweets, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDiff)
    }
    
    // Reconfigure/Reload the cell UI with the most updated data model
    private func update(tweet: Tweet, animatingDiff: Bool = false) {
        var snapshot = dataSource.snapshot()
        
        if #available(iOS 15.0, *) {
            snapshot.reconfigureItems([tweet])
        } else {
            snapshot.reloadItems([tweet])
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDiff)
    }
    
    private func getTweet(at indexPath: IndexPath) -> Tweet {
        let tweets = dataSource.snapshot().itemIdentifiers(inSection: .main)
       
        return tweets[indexPath.row]
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tweet = getTweet(at: indexPath)
        
        let previewViewController = TweetViewController(tweet: tweet)
        navigationController?.pushViewController(previewViewController, animated: true)
    }
}

extension TimelineViewController: UIContextMenuInteractionDelegate {

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }

        let tweet = getTweet(at: indexPath)
        
        // Creates a preview view controller to show a tweet in details
        let previewViewController = TweetViewController(tweet: tweet)
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: {
            
            // Shows the preview view controller when long pressing the cell
            return previewViewController
        }) { _ in
            
            // Defines menu items or actions related to the cell
            let visitAction = UIAction(title: "View \(tweet.author)'s tweet", image: nil) { [weak self] _ in
                self?.navigationController?.pushViewController(previewViewController, animated: true)
            }

            return UIMenu(title: "Actions", children: [visitAction])
        }
    }
}
