//
//  AttributedTweetStringMatch.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

struct AttributedTweetStringMatch {
    let attributedString: NSMutableAttributedString
    let mentionMatches: [NSTextCheckingResult]
    let linkMatches: [NSTextCheckingResult]

    private static func matchMentionsString(content: String, mutableAttributedString: NSMutableAttributedString) -> [NSTextCheckingResult] {
        // Highlight mentions starting with "@"
        let mentionPattern = "@\\w+"
        let mentionRegex = try? NSRegularExpression(pattern: mentionPattern, options: [])
        let mentionMatches = mentionRegex?.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))

        return mentionMatches ?? []
    }

    private static func matchLinkString(content: String, mutableAttributedString: NSMutableAttributedString) -> [NSTextCheckingResult] {
        guard let linkDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return []
        }

        let stringRange = NSRange(location: 0, length: mutableAttributedString.length)
        let linkMatches = linkDetector.matches(in: mutableAttributedString.string, options: [], range: stringRange)

        return linkMatches
    }

    init(content: String) {
        attributedString = NSMutableAttributedString(string: content)
        mentionMatches = AttributedTweetStringMatch.matchMentionsString(content: content, mutableAttributedString: attributedString)
        linkMatches = AttributedTweetStringMatch.matchLinkString(content: content, mutableAttributedString: attributedString)
    }
}
