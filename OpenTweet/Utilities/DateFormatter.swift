//
//  DateFormatter.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/15/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation


public func timestampConverter(timestamp: String) -> String {
    let dateFormatter = ISO8601DateFormatter()
    let dateString = dateFormatter.date(from: timestamp)
    
    let timestampFormatter = DateFormatter()
    timestampFormatter.dateFormat = "MM/dd/yyyy \u{2022} HH:mm:ss"
    timestampFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    if let dateString = dateString {
        return timestampFormatter.string(from: dateString)
    } else {
        return "Unknown"
    }
}
