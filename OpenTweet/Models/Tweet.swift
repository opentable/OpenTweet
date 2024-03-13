//
//  Tweet.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-12.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

final class Tweet: Hashable, Codable {
  let id: String
  let author: String
  let content: String
  let avatar: String?
  let date: Date
  let inReplyTo: String?
  
  var parentTweet: Tweet?
  var replies: [Tweet]?
  
  init(id: String, author: String, content: String, avatar: String?, date: Date, inReplyTo: String?, parentTweet: Tweet? = nil, replies: [Tweet]? = nil) {
    self.id = id
    self.author = author
    self.content = content
    self.avatar = avatar
    self.date = date
    self.inReplyTo = inReplyTo
    self.parentTweet = parentTweet
    self.replies = replies
  }
  
  static func == (lhs: Tweet, rhs: Tweet) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

struct Timeline: Codable {
  let timeline: [Tweet]
}
