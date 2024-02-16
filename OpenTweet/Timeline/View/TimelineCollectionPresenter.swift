//
//  TimelineCollectionPresenter.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TweetViewCellData>

class TimelineCollectionPresenter {

    private var dataSource: DataSource
    var tweets: [TweetViewCellData]

    init(dataSource: DataSource, tweets: [Tweet] = FileManager.default.loadData()) {
        self.dataSource = dataSource
        self.tweets = Self.tweetsCellSetup(from: tweets)
    }

    private static func tweetsCellSetup(from tweets: [Tweet]) -> [TweetViewCellData] {
        let sorted = tweets.sorted(by: { t1, t2 in
            t1.date > t2.date
        })
        var tweets = [TweetViewCellData]()
        sorted.forEach { tweet in
            let cellData = TweetViewCellData(
                author: tweet.author,
                content: tweet.content,
                date: tweet.date,
                avatar: tweet.avatar)
            tweets.append(cellData)
        }
        return tweets
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.tweets])
        snapshot.appendItems(tweets)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
