//
//  DateUtilsTests.swift
//  OpenTweetTests
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import XCTest

class DateUtilsTests: XCTestCase {
    func testFormatTimeAgoForDaysAgo() {
        let calendar = Calendar(identifier: .gregorian)
        let dateInPast = calendar.date(from: DateComponents(year: 2023, month: 1, day: 5, hour: 0, minute: 0, second: 0))!

        let formattedString = DateUtils.formatTimeAgo(from: dateInPast)
        XCTAssertEqual(formattedString, "January 5, 2023 at 12:00 AM") // Adjust this to match your date format
    }

    func testFormatTimeAgoForHoursAgo() {
        let calendar = Calendar(identifier: .gregorian)
        let dateInPast = calendar.date(byAdding: .hour, value: -3, to: .now)!

        let formattedString = DateUtils.formatTimeAgo(from: dateInPast)
        XCTAssertEqual(formattedString, "3 hours ago")
    }

    func testFormatTimeAgoForMinutesAgo() {
        let calendar = Calendar(identifier: .gregorian)
        let dateInPast = calendar.date(byAdding: .minute, value: -5, to: .now)!

        let formattedString = DateUtils.formatTimeAgo(from: dateInPast)
        XCTAssertEqual(formattedString, "5 minutes ago")
    }

    func testFormatTimeAgoForSecondsAgo() {
        let calendar = Calendar(identifier: .gregorian)
        let dateInPast = calendar.date(byAdding: .second, value: -30, to: .now)!

        let formattedString = DateUtils.formatTimeAgo(from: dateInPast)
        XCTAssertEqual(formattedString, "30 seconds ago")
    }

    func testFormatTimeAgoForJustNow() {
        let calendar = Calendar(identifier: .gregorian)
        let dateInPast = calendar.date(byAdding: .day, value: 2, to: .now)!

        let formattedString = DateUtils.formatTimeAgo(from: dateInPast)
        XCTAssertEqual(formattedString, "Just Now")
    }
}
