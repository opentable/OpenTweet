//
//  TweetReplyViewModel.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-28.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

final class TweetReplyViewModel: TweetReplyViewConfiguring {
    let mainTweetViewConfigurer: TweetViewConfiguring
    
    let replyTweetViewConfigurer: TweetViewConfiguring?
    
    init(mainTweet: Tweet, replyTweet: Tweet?) {
        mainTweetViewConfigurer = TweetViewModel(tweet: mainTweet)
        if let tweet = replyTweet {
            replyTweetViewConfigurer = TweetViewModel(tweet: tweet)
        } else {
            replyTweetViewConfigurer = nil
        }
    }
}
