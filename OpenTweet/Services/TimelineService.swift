//
//  TimelineService.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-12.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import Combine

protocol TimelineService {
  func fetchTimeline() -> AnyPublisher<Timeline, Error>
}

class TimelineServiceLocal: TimelineService {
  func fetchTimeline() -> AnyPublisher<Timeline, Error> {
    Bundle.main.decodeable(fileName: "timeline.json")
  }
}

#if DEBUG
class MockTimelineService: TimelineService {
  func fetchTimeline() -> AnyPublisher<Timeline, Error> {
    let tweets = [
      Tweet(id: "1", author: "David", content: "Hello world", avatar: "david", date: Date(), inReplyTo: nil),
      Tweet(id: "2", author: "David", content: "Goodbye world", avatar: "david", date: Date(), inReplyTo: nil),
    ]
    
    return Just(Timeline(timeline: tweets))
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
#endif
