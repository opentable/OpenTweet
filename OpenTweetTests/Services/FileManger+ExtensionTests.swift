//
//  FileManger+ExtensionTests.swift
//  OpenTweetTests
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

@testable import OpenTweet
import XCTest

class FileManger_ExtensionTests: XCTestCase {

    // MARK: - load data

    func test_loadData() {
        let tweets = FileManager.default.loadData()
        XCTAssertEqual(tweets.count, 7)
        let first = tweets[0]
        XCTAssertEqual(first.id, "00001")
        XCTAssertEqual(first.author, "@randomInternetStranger")
        XCTAssertEqual(first.content, "Man, I'm hungry. I probably should book a table at a restaurant or something. Wonder if there's an app for that?")
        XCTAssertEqual(first.avatar, "https://i.imgflip.com/ohrrn.jpg")

        XCTAssertEqual(first.date.description, "2020-09-29 22:41:00 +0000")
    }
}
