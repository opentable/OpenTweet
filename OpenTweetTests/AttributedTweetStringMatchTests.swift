//
//  AttributedTweetStringMatchTests.swift
//  OpenTweetTests
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import XCTest

class AttributedTweetStringMatchTests: XCTestCase {
    func testMentionMatches() {
        let content = "Hello @user1 and @user2! Mention these names: @user3 @user4"
        let tweetMatch = AttributedTweetStringMatch(content: content)
        
        XCTAssertEqual(tweetMatch.mentionMatches.count, 4)
        XCTAssertEqual(tweetMatch.mentionMatches[0].range, NSRange(location: 6, length: 6)) // @user1
        XCTAssertEqual(tweetMatch.mentionMatches[1].range, NSRange(location: 17, length: 6)) // @user2
        XCTAssertEqual(tweetMatch.mentionMatches[2].range, NSRange(location: 46, length: 6)) // @user3
        XCTAssertEqual(tweetMatch.mentionMatches[3].range, NSRange(location: 53, length: 6)) // @user4
    }

    func testLinkMatches() {
        let content = "Check out this https://opentable.com or search http://google.com or try short.google.com"
        let tweetMatch = AttributedTweetStringMatch(content: content)
        
        XCTAssertEqual(tweetMatch.linkMatches.count, 3)
        XCTAssertEqual(tweetMatch.linkMatches[0].range, NSRange(location: 15, length: 21))
        XCTAssertEqual(tweetMatch.linkMatches[1].range, NSRange(location: 47, length: 17))
        XCTAssertEqual(tweetMatch.linkMatches[2].range, NSRange(location: 72, length: 16))
    }
    
    func testMentionDoesntMatches() {
        let content = "Hello @ user1 and @@.user2!"
        let tweetMatch = AttributedTweetStringMatch(content: content)
        
        XCTAssertEqual(tweetMatch.linkMatches.count, 0)
    }
    
    func testMentionAndLinkMatches() {
            let content = "Hello @user1 and @user2! Mention these names: @user3 @user4. Check out this https://opentable.com or search http://google.com"
            let tweetMatch = AttributedTweetStringMatch(content: content)
            
            // Mention Matches
            XCTAssertEqual(tweetMatch.mentionMatches.count, 4)
            XCTAssertEqual(tweetMatch.mentionMatches[0].range, NSRange(location: 6, length: 6))
            XCTAssertEqual(tweetMatch.mentionMatches[1].range, NSRange(location: 17, length: 6))
            XCTAssertEqual(tweetMatch.mentionMatches[2].range, NSRange(location: 46, length: 6))
            XCTAssertEqual(tweetMatch.mentionMatches[3].range, NSRange(location: 53, length: 6))

            // Link Matches
            XCTAssertEqual(tweetMatch.linkMatches.count, 2)
            XCTAssertEqual(tweetMatch.linkMatches[0].range, NSRange(location: 76, length: 21))
            XCTAssertEqual(tweetMatch.linkMatches[1].range, NSRange(location: 108, length: 17))
        }
}
