//
//  Tweet.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-11.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

final class Tweet: Codable {
    let id: String
    let author: String
    let content: String
    let date: String
    let avatar: String?
    let inReplyTo: String?

    var tweetRepliesTo: Tweet?
    var tweetReplies: [Tweet]?
}

extension Tweet: Hashable {
    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
