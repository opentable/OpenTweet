//
//  TweetObject.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

// MARK: - Timeline
struct Timeline: Codable {
    var timeline: [TweetObject]
}

// MARK: - TweetObject
struct TweetObject: Codable {
    let id, author, content: String
    let avatar: String?
    let date: Date
    let inReplyTo: String?
}
