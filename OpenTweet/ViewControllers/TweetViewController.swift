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
        case replyTo
        case replies
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
        navigationController?.navigationBar.tintColor = .label
        
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
        
        if let replyToTweet = viewModel.replyToTweet {
            snapshot.appendSections([.replyTo])
            snapshot.appendItems([replyToTweet], toSection: .replyTo)
        }
        
        if viewModel.replies.count > 0 {
            snapshot.appendSections([.replies])
            snapshot.appendItems(viewModel.replies, toSection: .replies)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDiff)
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let snapshot = dataSource.snapshot()
        let sections = snapshot.sectionIdentifiers
        
        return makeHeaderView(for: sections[section])
    }
    
    private func makeHeaderView(for section: Section) -> UIView? {
        if section == .main { return nil }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray

        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 10)
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 5),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        switch section {
        case .main:
            break
        case .replyTo:
            titleLabel.text = "Repling to:"
        case .replies:
            titleLabel.text = "Replies:"
        }
        
        return headerView
    }
}
