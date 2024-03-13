//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-12.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import Combine

class TimelineViewModel: ObservableObject {
  enum State {
    case idle
    case loading
    case success(tweets: [Tweet])
    case error(Error)
  }
  
  @Published var state: State = .idle
  
  private var timelineService: TimelineService
  private var subscriptions = Set<AnyCancellable>()
  
  init(timelineService: TimelineService) {
    self.timelineService = timelineService
  }
  
  func fetchTimeline() {
    state = .loading
    timelineService.fetchTimeline()
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          self?.state = .error(error)
        case .finished:
          break
        }
      } receiveValue: { [weak self] data in
        self?.state = .success(tweets: data.timeline.sorted { $0.date < $1.date })
      }
      .store(in: &subscriptions)
  }
}
