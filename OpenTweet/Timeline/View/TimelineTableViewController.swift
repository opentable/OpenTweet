//
//  TimelineTableViewController.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-15.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TweetViewCell"

class TimelineTableViewController: UITableViewController {

    private var viewModel = TimelineCollectionPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Timeline"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }

        // Configure the cell
        cell.setup(with: viewModel.getTweet(at: indexPath.row), isSelected: viewModel.selectedRow == indexPath.row)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(row: indexPath.row)
        tableView.reloadData()
    }
}
