//
//  TimelineTableViewController.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-15.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

enum Section {
    case tweets
}

typealias DataSource = UITableViewDiffableDataSource<Section, TweetViewCellData>

class TimelineTableViewController: UITableViewController {

    private var presenter: TimelineCollectionPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Timeline"
        presenter = TimelineCollectionPresenter(dataSource: makeDataSource())
        presenter.applySnapshot(animatingDifferences: false)
        addPullToRefresh()
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, data) -> UITableViewCell? in
                return self.setupCell(tableView, indexPath, data)
            })
        return dataSource
    }

    private func setupCell(_ tableView: UITableView,
                           _ indexPath: IndexPath,
                           _ data: TweetViewCellData) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TweetTableViewCell.reuseIdentifier,
            for: indexPath) as? TweetTableViewCell
        cell?.setup(with: data)
        return cell
    }

    private func addPullToRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                        action: #selector(pulldown), for: .valueChanged)
        tableView.refreshControl?.tintColor = .clear
    }

    @objc func pulldown() {
        presenter.loadNewTweets(from: FileManager.default.getNewsTweet())
//        table.reloadData()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
}
