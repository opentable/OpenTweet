//
//  Strings.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import Foundation

enum LocalizableStrings: String {
    case inReplyTo
    case error
    case replies

    var stringValue: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
