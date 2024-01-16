//
//  Tweet.swift
//  OpenTweet
//
//  Created by Dante Li on 2024-01-14.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

struct Timeline: Codable {
    let timeline: [Tweet]
}

class Tweet: Codable, Hashable {
    
    let id: String
    let author: String
    let content: String
    let avatarLink: String?
    let dateString: String
    let replyTo: String?
    var avatarData: Data?
    var tweetReplyTo: Tweet?
    var replies: [Tweet] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case content
        case avatarLink = "avatar"
        case dateString = "date"
        case replyTo = "inReplyTo"
    }
    
    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
