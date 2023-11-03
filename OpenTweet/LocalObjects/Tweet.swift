//
//  Tweet.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

struct Tweet: Identifiable, Hashable {
    let id, author, content: String
    let avatar: String?
    let date: Date
    let inReplyTo: String?
}

extension TweetObject {
    func toTweet() -> Tweet {
        return Tweet(id: id, author: author, content: content, avatar: avatar, date: date, inReplyTo: inReplyTo)
    }
}
