//
//  OpenTweetUITests.swift
//  OpenTweetUITests
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import XCTest

final class OpenTweetUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTweetDetails() throws {
        let app = XCUIApplication()
        app.launch()
        let tweetCell = app.buttons["TweetCell"].firstMatch

        XCTAssertTrue(tweetCell.exists)

        tweetCell.tap()
        
        let detailsView = app.navigationBars["Man, I'm hungry. I probably should book a table at a restaurant or something. Wonder if there's an app for that?"]
        XCTAssertTrue(detailsView.waitForExistence(timeout: 5))
    }
    
    func testUserDetails() throws {
        let app = XCUIApplication()
        app.launch()
        let tweetCell = app.buttons["@randomInternetStranger"].firstMatch

        XCTAssertTrue(tweetCell.exists)

        tweetCell.tap()

        let detailsView = app.navigationBars["@randomInternetStranger"]

        XCTAssertTrue(detailsView.waitForExistence(timeout: 5))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
