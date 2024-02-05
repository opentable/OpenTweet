//
//  TimelineCollectionPresenter.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineCollectionPresenter {

    private var tweets: [TweetViewCellData]
    var selectedRow = -1

    var sections: Int {
        return 1
    }

    var items: Int {
        return tweets.count
    }

    init(tweets: [Tweet] = FileManager.default.loadData()) {
        let sorted = tweets.sorted(by: { t1, t2 in
            t1.date > t2.date
        })
        self.tweets = [TweetViewCellData]()
        sorted.forEach { tweet in
            let cellData = TweetViewCellData(
                author: tweet.author,
                content: tweet.content,
                date: tweet.date,
                avatar: tweet.avatar)
            self.tweets.append(cellData)
        }
    }

    func getTweet(at index: Int) -> TweetViewCellData {
        return tweets[index]
    }

    func select(row: Int) {
        if selectedRow == row {
            selectedRow = -1
        } else {
            selectedRow = row
        }
    }
}
