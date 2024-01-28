//
//  DateUtils.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

enum DateUtils {
    /// This method converts Date object to a formatted date string
    /// ex: "2024-01-01T00:00:00" -> "January 1, 2024 at 12:00 AM"
    static func formatTimeAgo(from date: Date) -> String {
        let currentDate = Date()
        let timeDifference = currentDate.timeIntervalSince(date)
        
        if timeDifference < 30 {
            return "Just Now"
        } else if timeDifference < 60 {
            let seconds = Int(timeDifference)
            return "\(seconds) seconds ago"
        } else if timeDifference < 3600 {
            let minutes = Int(timeDifference / 60)
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else if timeDifference < 86400 {
            let hours = Int(timeDifference / 3600)
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.dateFormat
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone.current
            
            return dateFormatter.string(from: date)
        }
    }
}
