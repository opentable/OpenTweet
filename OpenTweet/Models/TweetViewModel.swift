//
//  TweetViewModel.swift
//  OpenTweet
//
//  Created by Dante Li on 2024-01-15.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

protocol TweetViewModel {
    
    var mainTweet: Tweet { get }
    var replyToTweet: Tweet? { get }
    var replies: [Tweet] { get }
}

final class TweetviewModelImpl: TweetViewModel{
    
    var mainTweet: Tweet {
        tweet
    }
    
    var replyToTweet: Tweet? {
        tweet.tweetReplyTo
    }
    
    var replies: [Tweet] {
        tweet.replies
    }
    
    private let tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
}
