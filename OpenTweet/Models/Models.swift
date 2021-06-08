//
//  Models.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/15/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

struct TimelineData: Codable {
    let timeline: [TimelineTweet]
}

struct TimelineTweet: Codable {
    let id: String
    let author: String
    let content: String
    let date: String
    let avatar: String?
    let inReplyTo: String?
    let images: [Image]?
}

struct Image: Codable {
    let imageURL: String
}
