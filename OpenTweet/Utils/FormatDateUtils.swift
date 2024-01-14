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
    ///     - rawDateString: The ISO 8601 format string input that represents a specifi time point.
    /// - Returns: A date string in MMMM dd, yyyy HH:mm:ss format.
    static func format(rawDateString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        
        if let date = isoFormatter.date(from: rawDateString) {
            
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
