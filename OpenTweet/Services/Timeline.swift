//
//  Tweet.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let timeline = try? JSONDecoder().decode(Timeline.self, from: jsonData)

import Foundation

// MARK: - Timeline
struct Timeline: Codable {
    let timeline: [Tweet]
}

// MARK: - Tweet
struct Tweet: Codable, Equatable {
    let id, author, content: String
    let avatar: String?
    let date: Date
    let inReplyTo: String?
}


