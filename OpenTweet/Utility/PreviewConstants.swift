//
//  Constants.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

enum PreviewConstants {
    static let tweet: Tweet = Tweet(
        id: "00001",
        author: "@landonr",
        content: "Test tweet @landonr should be on the store next week.\nhttps://itunes.apple.com/us/app/opentable/id296581815?mt=8",
        avatar: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/PNG_Test.png/477px-PNG_Test.png?20231028084532",
        date: .now,
        inReplyTo: nil
    )
    static let replyTweet: Tweet = Tweet(
        id: "00002",
        author: "@randomInternetStranger",
        content: "I'll check it out!",
        avatar: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/PNG_Test.png/477px-PNG_Test.png?20231028084532",
        date: .now.advanced(by: -36000),
        inReplyTo: "00001"
    )
    static let shortTweet: Tweet = Tweet(
        id: "00002",
        author: "@randomInternetStranger",
        content: "cool",
        avatar: nil,
        date: .now,
        inReplyTo: nil
    )
}
