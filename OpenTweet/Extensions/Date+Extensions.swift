//
//  Date+Extensions.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-12.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

extension Date {
  func timelineTimestamp() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
    return formatter.string(from: self)
  }
}
