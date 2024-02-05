//
//  TweetViewCellPresenterTests.swift
//  OpenTweetTests
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

@testable import OpenTweet
import XCTest

class TweetViewCellPresenterTests: XCTestCase {

    private var tweetViewCellData: TweetViewCellPresenter!

    override func setUp() {
        super.setUp()
        let cellData = TweetViewCellData(author: "Alice",
                                      content: "content",
                                      date: Date(timeIntervalSince1970: 0),
                                      avatar: nil)
        tweetViewCellData = TweetViewCellPresenter(cellData: cellData)
    }

    // MARK: - author
    func test_author() {
        XCTAssertEqual(tweetViewCellData.author, "Alice")
    }

    // MARK: - avatar image
    func test_avatarImage() {
        XCTAssertNotNil(tweetViewCellData.avatarImage)
    }

    // MARK: - content
    func test_content() {
        let expected = NSMutableAttributedString(string: "content")
        XCTAssertEqual(tweetViewCellData.content, expected)
    }

    // MARK: - date
    func test_date() {
        XCTAssertEqual(tweetViewCellData.date, "Dec 31, 1969 at 7:00 PM")
    }
}
