//
//  TimelineCollectionPresenterTests.swift
//  OpenTweetTests
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

@testable import OpenTweet
import XCTest

final class TimelineCollectionPresenterTests: XCTestCase {

    private var viewModel: TimelineCollectionPresenter!

    private let oldTweet = Tweet(id: "1",
                                 author: "alice",
                                 content: "content",
                                 avatar: nil,
                                 date: Date(),
                                 inReplyTo: nil)
    private let newTweet = Tweet(id: "2",
                                 author: "bob",
                                 content: "diff",
                                 avatar: nil,
                                 date: Date().addingTimeInterval(50_000),
                                 inReplyTo: nil)

    override func setUp() {
        viewModel = TimelineCollectionPresenter(tweets: [oldTweet, newTweet])
    }

    // MARK: - sections
    func test_sections() {
        XCTAssertEqual(viewModel.sections, 1)
    }

    // MARK: - items
    func test_items() {
        XCTAssertEqual(viewModel.items, 2)
    }

    // MARK: - getTweet
    func test_getTweet() {
        let tweet = viewModel.getTweet(at: 0)
        XCTAssertEqual(tweet.author, newTweet.author)
    }
}
