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

    func formattedDate() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
}

extension TweetObject {
    func toTweet() -> Tweet {
        return Tweet(id: id, author: author, content: content, avatar: avatar, date: date, inReplyTo: inReplyTo)
    }
}
