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
}
