//
//  Tweet.swift
//  OpenTweet
//
//  Created by Iryna Rivera on 5/19/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

struct Timeline: Codable {
    let timeline: [TweetInfo]
}

struct TweetInfo: Codable {
    let id: String
    let author: String
    let content: String
    let date: String
}
