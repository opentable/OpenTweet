//
//  Tweet.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-12.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

struct Tweet: Hashable, Codable {
  let id: String
  let author: String
  let content: String
  let avatar: String?
  let date: Date
  let inReplyTo: String?
}

struct Timeline: Codable {
  let timeline: [Tweet]
}
