//
//  OpenTweetUITests.swift
//  OpenTweetUITests
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import XCTest

class OpenTweetUITests: XCTestCase {
    
    private let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_timelineScreenIsInitialScreen() {
        XCTAssertTrue(app.navigationBars.firstMatch.identifier == "Timeline")
        
    }
    
    func test_tappingOnTimelineScreen_opensThreadScreen() {
        app.staticTexts["@randomInternetStranger"].firstMatch.tap()
        XCTAssertTrue(app.navigationBars.firstMatch.identifier == "Thread")
    }
    
}
