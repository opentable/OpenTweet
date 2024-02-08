//
//  OpenTweetTests.swift
//  OpenTweetTests
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

class OpenTweetTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testFetchLocalTimeline() {
        let exp = expectation(description: "Timeline loads")
        var maybeResult: Result<Timeline, Swift.Error>?
        LocalAPI().fetchTimeline { result in
            maybeResult = result
            exp.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(maybeResult)
        switch maybeResult! {
        case .failure: XCTFail()
        default: break
        }
    }
}
