//
//  Constants.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

enum Constants {
    enum Dimens {
        static let cellCornerRadius: CGFloat = 5
        static let padding: CGFloat = 12
    }
    
    enum TweetCell {
        static let reuseIdentifier = "OpenTweet.TweetCell"
        static let avatarImageHeight: CGFloat = 50
        static let avatarImageWidth: CGFloat = 50
        static let avatarImageCornerRadius: CGFloat = 20
    }
    
    enum ThreadHeader {
        static let reuseIdentifier = "OpenTweet.ThreadHeaderView"
    }
    
    enum TimelineService {
        static let fileName = "timeline"
        static let fileType = "json"
    }
    
    enum TimelineView {
        static let title = "Timeline"
    }
    
    enum ThreadView {
        static let title = "Thread"
        static let headerHeight: CGFloat = 40
        static let originalTweetHeaderTitle = "Tweet Details"
        static let tweetRepliesToHeaderTitle = "Replies To"
        static let tweetRepliesHeaderTitle = "Replies"
    }
}
