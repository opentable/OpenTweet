//
//  DateUtilTests.swift
//  OpenTweetTests
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

@available(iOS 15, *)
class DateUtilsTests: XCTestCase {
    func testFormatTimeAgoForDaysAgo() {
        let calendar = Calendar(identifier: .gregorian)
        let dateInPast = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1, hour: 0, minute: 0, second: 0))!

        let formattedString = DateUtils.formatTimeAgo(from: dateInPast)
        XCTAssertEqual(formattedString, "January 1, 2024 at 12:00 AM") // Adjust this to match your date format
    }

    func testFormatTimeAgoForHoursAgo() {
        let calendar = Calendar(identifier: .gregorian)
        let dateInPast = calendar.date(byAdding: .hour, value: -2, to: .now)!

        let formattedString = DateUtils.formatTimeAgo(from: dateInPast)
        XCTAssertEqual(formattedString, "2 hours ago")
    }

    func testFormatTimeAgoForMinutesAgo() {
        let calendar = Calendar(identifier: .gregorian)
        let dateInPast = calendar.date(byAdding: .minute, value: -10, to: .now)!

        let formattedString = DateUtils.formatTimeAgo(from: dateInPast)
        XCTAssertEqual(formattedString, "10 minutes ago")
    }

    func testFormatTimeAgoForSecondsAgo() {
        let calendar = Calendar(identifier: .gregorian)
        let dateInPast = calendar.date(byAdding: .second, value: -45, to: .now)!

        let formattedString = DateUtils.formatTimeAgo(from: dateInPast)
        XCTAssertEqual(formattedString, "45 seconds ago")
    }

    func testFormatTimeAgoForJustNow() {
        let calendar = Calendar(identifier: .gregorian)
        let dateInPast = calendar.date(byAdding: .day, value: 2, to: .now)!

        let formattedString = DateUtils.formatTimeAgo(from: dateInPast)
        XCTAssertEqual(formattedString, "Just Now")
    }
}
