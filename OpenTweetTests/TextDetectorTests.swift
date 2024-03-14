//
//  TextDetector.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

class TextDetectorTests: XCTestCase {
  func test_mentionDetector_singleMention() {
    let detector = MentionDetector()
    let matches = detector.matches(in: "Hello @world")
    XCTAssertEqual(matches.count, 1)
  }
  
  func test_mentionsDetector_multipleMentions() {
    let detector = MentionDetector()
    let matches = detector.matches(in: "Hello @world @hi @this is #me")
    XCTAssertEqual(matches.count, 3)
  }
  
  func test_mentionsDetector_rangeOfMention() {
    let detector = MentionDetector()
    let matches = detector.matches(in: "Hello @world")
    XCTAssertEqual(matches.first?.range, NSRange(location: 6, length: 6))
  }
  
  func test_linkDetector_singleLink() {
    let detector = LinkDetector()
    let matches = detector.matches(in: "Hello https://world.com")
    XCTAssertEqual(matches.count, 1)
  }
  
  func test_linkDetector_multipleLinks() {
    let detector = LinkDetector()
    let matches = detector.matches(in: "Hello https://world.com https://www.big.com www.earth.com")
    XCTAssertEqual(matches.count, 3)
  }
  
  func test_linkDetector_rangeOfLink() {
    let detector = LinkDetector()
    let matches = detector.matches(in: "Hello https://world.com")
    XCTAssertEqual(matches.first?.range, NSRange(location: 6, length: 17))
  }
}
