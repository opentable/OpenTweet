//
//  DateUtils.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import Foundation

class DateUtils {
    static func formatTimeAgo(from date: Date) -> String {
        // date is returned in gregorian calendar!
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: now)

        if let days = components.day, days > 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = DisplayConstants.dateFormat
            return formatter.string(from: date)
        } else if let hours = components.hour, hours > 0 {
            return String.localizedStringWithFormat(LocalizableStrings.hoursAgo.stringValue, hours)
        } else if let minutes = components.minute, minutes > 0 {
            return String.localizedStringWithFormat(LocalizableStrings.minutesAgo.stringValue, minutes)
        } else if let seconds = components.second, seconds >= 30 {
            return String.localizedStringWithFormat(LocalizableStrings.secondsAgo.stringValue, seconds)
        } else {
            return NSLocalizedString(LocalizableStrings.justNow.stringValue, comment: "")
        }
    }
}
