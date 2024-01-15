//
//  TweetTableViewController.swift
//  OpenTweet
//
//  Created by Dante Li on 2024-01-15.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

final class TweetViewController: UITableViewController {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Tweet>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Tweet>
    
    private let viewModel: TweetViewModel
    
    private lazy var dataSource: DataSource = makeDataSource()
    
    // MARK: - Init
    
    init(tweet: Tweet) {
        self.viewModel = TweetviewModelImpl(tweet: tweet)
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TimelineTableViewCell.self, forCellReuseIdentifier: "\(TimelineTableViewCell.self)")
        
        applySnapshot(tweets: [viewModel.mainTweet])
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
        
        dataSource.apply(snapshot, animatingDifferences: animatingDiff)
    }
}
