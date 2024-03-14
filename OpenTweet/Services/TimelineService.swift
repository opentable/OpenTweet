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
    Bundle.main.decodable(fileName: "timeline.json")
  }
}

#if DEBUG
class MockTimelineService: TimelineService {
  let throwFailure: Bool
  let mockDelay: Bool
  let mockTimeline: Timeline
  
  static let defaultTweets = Timeline(timeline: [
         mockTweet(messageNumber: 1),
         mockTweet(messageNumber: 2),
  ])
  
  init(throwFailure: Bool = false, mockDelay: Bool = false, mockTimeline: Timeline? = nil) {
    self.throwFailure = throwFailure
    self.mockDelay = mockDelay
    self.mockTimeline = mockTimeline ?? MockTimelineService.defaultTweets
  }
  
  func fetchTimeline() -> AnyPublisher<Timeline, Error> {
    if throwFailure {
      return Fail(error: URLError(.cannotDecodeContentData))
        .eraseToAnyPublisher()
    } else {
      return Just(mockTimeline)
        .delay(for: mockDelay ? 5 : 0, scheduler: RunLoop.main)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
  }
  
  static func mockTweet(messageNumber: Int, isShortMessage: Bool = false) -> Tweet {
    let id = String(messageNumber)
    let author = "mockUser" + String(Int.random(in: 0...messageNumber))
    let content = isShortMessage ? "Really short message" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."
    return Tweet(id: id, author: "@\(author)", content: content, avatar: nil, date: Date(), inReplyTo: nil)
  }
}
#endif
