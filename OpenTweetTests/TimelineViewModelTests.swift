//
//  TimelineViewModelTests.swift
//  OpenTweetTests
//
//  Created by Sean Lee on 2024-01-28.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import XCTest
import Combine
@testable import OpenTweet

final class TimelineViewModelTests: XCTestCase {
    var viewModel: TimelineViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = TimelineViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchTweets() {
        // Given
        let expectation = expectation(description: "Fetching tweets")
        var receivedTweets: [Tweet]?

        // When
        viewModel.publisher
            .sink { tweets in
                receivedTweets = tweets
                if receivedTweets?.isEmpty == false {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchTweets()

        // Then
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Timeout waiting for expectation")
            XCTAssertNotNil(receivedTweets)
            XCTAssertEqual(receivedTweets?.count, 7)
            XCTAssert(receivedTweets?[0].id == "00001")
        }
    }
    
}
