//
//  TweetParserTests.swift
//  OpenTweetTests
//
//  Created by Michael Charland on 2024-02-06.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

@testable import OpenTweet
import XCTest

class TweetParserTests: XCTestCase {

    private let tweetParser = TweetParser()
    private let mentionHighlight = MentionReplacer().getAttributes(value: "")
    
    // MARK: - mentions

    func test_oneMention() {
        let content = "@elon I just bought Twitter"
        let actual = tweetParser.generateContent(from: content)
        let expected = NSMutableAttributedString(string: "@elon",
                                                 attributes: mentionHighlight)
        expected.append(NSAttributedString(string: " I just bought Twitter"))

        XCTAssertEqual(actual, expected)
    }

    func test_twoMentions() {
        let content = "@alice @bob Have you tried OpenTable?"
        let actual = tweetParser.generateContent(from: content)
        let expected = NSMutableAttributedString(string: "@alice",
                                                 attributes: mentionHighlight)
        expected.append(NSAttributedString(string: " "))
        expected.append(NSAttributedString(string: "@bob",
                                           attributes: mentionHighlight))
        expected.append(NSAttributedString(string: " Have you tried OpenTable?"))

        XCTAssertEqual(actual, expected)
    }

    // MARK: - url

    func test_oneURL() {
        let url = "https://www.opentable.ca/"
        let content = "Have you tried OpenTable? \(url)"
        let actual = tweetParser.generateContent(from: content)
        let expected = NSMutableAttributedString(string: "Have you tried OpenTable? ")
        expected.append(NSAttributedString(string: url,
                                           attributes: [.link: URL(string: url)!]))

        XCTAssertEqual(actual, expected)
    }

    func test_twoURLs() {
        let url = "https://www.opentable.ca/"
        let url2 = "https://www.opentable.com/"
        let content = "\(url) Have you tried OpenTable? \(url2)"
        let actual = tweetParser.generateContent(from: content)
        let expected = NSMutableAttributedString(string: url,
                                                 attributes: [.link : URL(string: url)!])
        expected.append(NSAttributedString(string: " Have you tried OpenTable? "))
        expected.append(NSAttributedString(string: url2,
                                           attributes: [.link: URL(string: url2)!]))

        XCTAssertEqual(actual, expected)
    }


}
