//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Combine
import UIKit

class TimelineViewController: UITableViewController {
    
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
            tableView: tableView) { tableView, indexPath, tweet in
                let cell = tableView.dequeueReusableCell(withIdentifier: "\(TimelineTableViewCell.self)", for: indexPath) as? TimelineTableViewCell
                cell?.tweet = tweet
                return cell
            }
    
        return ds
    }
    
    private func applySnapshot(tweets: [Tweet], animatingDiff: Bool = false) {
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(tweets, toSection: .main)
        
        dataSource.apply(snapshot)
    }
}
