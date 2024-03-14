//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-12.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Combine
import XCTest
@testable import OpenTweet

class TimelineViewModelTests: XCTestCase {
  var subscriptions: Set<AnyCancellable>!
  
  override func setUp() {
    subscriptions = Set<AnyCancellable>()
  }
  
  override func tearDown() {
    subscriptions = nil
    super.tearDown()
  }
  
  func test_fetchTimeline() {
    let expectation = XCTestExpectation(description: "Fetch timeline")
    let mockTimelineService = MockTimelineService(throwFailure: false)
    let viewModel = TimelineViewModel(timelineService: mockTimelineService)
    viewModel.$state
      .dropFirst()
      .sink { state in
        switch state {
        case .success(let tweets):
          XCTAssertNotNil(tweets)
          expectation.fulfill()
        default:
          break
        }
      }
      .store(in: &subscriptions)
    
    viewModel.fetchTimeline()
    wait(for: [expectation], timeout: 5)
  }
  
  func test_idleState() {
    let mockTimelineService = MockTimelineService(throwFailure: false)
    let viewModel = TimelineViewModel(timelineService: mockTimelineService)
    XCTAssertEqual(viewModel.state, .idle)
  }
  
  func test_loadingState() {
    let mockTimelineService = MockTimelineService(throwFailure: false, mockDelay: true)
    let viewModel = TimelineViewModel(timelineService: mockTimelineService)
    XCTAssertEqual(viewModel.state, .idle)
    viewModel.fetchTimeline()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      XCTAssertEqual(viewModel.state, .loading)
    }
  }
  
  func test_successState() {
    let timeline = Timeline(timeline: [
      MockTimelineService.mockTweet(messageNumber: 1),
      MockTimelineService.mockTweet(messageNumber: 2),
      MockTimelineService.mockTweet(messageNumber: 3),
    ])
    let dataService = MockTimelineService(mockTimeline: timeline)
    let viewModel = TimelineViewModel(timelineService: dataService)
    XCTAssertEqual(viewModel.state, .idle)
    
    viewModel.fetchTimeline()
    // Simulate the asynchronous data loading
    DispatchQueue.main.async {
      XCTAssertEqual(viewModel.state, .success(tweets: timeline.timeline))
    }
  }
  
  func test_errorState() {
    let mockTimelineService = MockTimelineService(throwFailure: true)
    let viewModel = TimelineViewModel(timelineService: mockTimelineService)
    
    XCTAssertEqual(viewModel.state, .idle)
    viewModel.fetchTimeline()
    DispatchQueue.main.async {
      XCTAssertEqual(viewModel.state, .error(.decodingError))
    }
  }
}
