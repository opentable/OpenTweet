//
//  TweetsController.swift
//  OpenTweet
//
//  Created by Iryna Rivera on 5/19/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol TweetsControllerProtocol: class {
    var presenter: TweetsPresenterProtocol! { get set }
    
    func show(_ tweets: [TweetInfo])
}

class TweetsController: UITableViewController, TweetsControllerProtocol {
    var presenter: TweetsPresenterProtocol!
    private var tweets = [TweetInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter.loadInitialData()
    }

    // MARK: - Preparations
    private func applyStyle() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    func show(_ tweets: [TweetInfo]) {
        self.tweets = tweets
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet Cell", for: indexPath) as! TweetCell
        cell.update(model)
        cell.editDateFormat()
        return cell
    }        
}
