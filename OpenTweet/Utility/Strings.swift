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
    case secondsAgo
    case minutesAgo
    case hoursAgo
    case justNow
    case posts
    case followers
    case following

    var stringValue: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
