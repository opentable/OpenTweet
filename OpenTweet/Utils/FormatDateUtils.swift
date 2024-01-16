//
//  FormatDateUtils.swift
//  OpenTweet
//
//  Created by Dante Li on 2024-01-14.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

struct FormatDateUtils {
    
    /// Returns the date string based on a time point whose foramt is ISO 8601.
    ///
    /// - Parameters
    ///     - rawDateString: The ISO 8601 format string input that represents a specific time point.
    /// - Returns: A date string in MMMM dd, yyyy HH:mm:ss format.
    static func format(rawDateString: String) -> String? {
        if let date = rawDateString.iso8601Date {
            
            // Create a date formatter for the desired output format
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM dd, yyyy HH:mm:ss"

            // Convert the date to the desired format
            let outputString = outputFormatter.string(from: date)
            print("Converted Date: \(outputString)")
            return outputString
        }
        
        return nil
    }
}

extension String {
    
    /// Coverts the string to a `Date` if it is in ISO 8601 format
    var iso8601Date: Date? {
        let isoFormatter = ISO8601DateFormatter()
        
        return isoFormatter.date(from: self)
    }
}
