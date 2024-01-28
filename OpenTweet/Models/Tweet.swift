//
//  Tweet.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

final class Tweet: Codable, Hashable {
    let id: String
    let author: String
    let content: String
    let avatar: String?
    let date: String
    let inReplyTo: String?
    
    var replyToTweet: Tweet?
    var tweetReplies: [Tweet] = []
    
    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case content
        case avatar
        case date
        case inReplyTo
    }
    
    func getDateFromTweet() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: date) {
            return date
        }
        return Date()
    }
    
    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class Timeline: Codable {
    let timeline: [Tweet]
}
