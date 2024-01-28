//
//  AttributedStringBuilderTests.swift
//  OpenTweetTests
//
//  Created by Sean Lee on 2024-01-28.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

class AttributedStringBuilderTests: XCTestCase {

    func testInit_AttributedStringNotEmpty() {
        // Given
        let inputString = "This is a test string"
        
        // When
        let builder = AttributedStringBuilder(string: inputString)
        
        // Then
        XCTAssertFalse(builder.attributedString.string.isEmpty, "Attributed string should not be empty")
    }

    func testInit_MentionMatchesNotEmpty() {
        // Given
        let inputString = "Hello @John, how are you doing?"
        
        // When
        let builder = AttributedStringBuilder(string: inputString)
        
        // Then
        XCTAssertFalse(builder.mentionMatches.isEmpty, "Mention matches should not be empty")
    }

    func testInit_LinkMatchesNotEmpty() {
        // Given
        let inputString = "Visit our website at https://example.com"
        
        // When
        let builder = AttributedStringBuilder(string: inputString)
        
        // Then
        XCTAssertFalse(builder.linkMatches.isEmpty, "Link matches should not be empty")
    }

    func testInit_NoMentionsInString() {
        // Given
        let inputString = "This string does not contain any mentions"
        
        // When
        let builder = AttributedStringBuilder(string: inputString)
        
        // Then
        XCTAssertTrue(builder.mentionMatches.isEmpty, "Mention matches should be empty")
    }

    func testInit_NoLinksInString() {
        // Given
        let inputString = "This string does not contain any links"
        
        // When
        let builder = AttributedStringBuilder(string: inputString)
        
        // Then
        XCTAssertTrue(builder.linkMatches.isEmpty, "Link matches should be empty")
    }
}
