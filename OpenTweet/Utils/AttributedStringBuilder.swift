//
//  AttributedStringBuilder.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-27.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

/// Utility class to help parse strings and find matches for links/mentions for formatting
struct AttributedStringBuilder {
    let attributedString: NSMutableAttributedString
    let mentionMatches: [NSTextCheckingResult]
    let linkMatches: [NSTextCheckingResult]

    private static func matchMentionsString(string: String, mutableAttributedString: NSMutableAttributedString) -> [NSTextCheckingResult] {
        // Highlight mentions starting with "@"
        let mentionPattern = "@\\w+"
        let mentionRegex = try? NSRegularExpression(pattern: mentionPattern, options: [])
        let mentionMatches = mentionRegex?.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))

        return mentionMatches ?? []
    }

    private static func matchLinkString(string: String, mutableAttributedString: NSMutableAttributedString) -> [NSTextCheckingResult] {
        guard let linkDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return []
        }

        let stringRange = NSRange(location: 0, length: mutableAttributedString.length)
        let linkMatches = linkDetector.matches(in: mutableAttributedString.string, options: [], range: stringRange)

        return linkMatches
    }

    init(string: String) {
        attributedString = NSMutableAttributedString(string: string)
        mentionMatches = Self.matchMentionsString(string: string, mutableAttributedString: attributedString)
        linkMatches = Self.matchLinkString(string: string, mutableAttributedString: attributedString)
    }
}
