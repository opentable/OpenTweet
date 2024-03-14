//
//  TweetCellViewModel.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

final class TweetCellViewModel {
    var tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
}

extension TweetCellViewModel: TweetCellInterface {
    var userAvatarImageUrl: String? {
        return tweet.avatar
    }
    
    var authorLabelText: String {
        return tweet.author
    }
    
    var dateLabelText: String {
        let formatter = ISO8601DateFormatter()

        if let date = formatter.date(from: tweet.date) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            return outputDateFormatter.string(from: date)
        }

        return tweet.date
    }
    
    var contentLabelAttributedText: NSMutableAttributedString {
        let content = tweet.content
        return buildAttributedText(from: content)
    }
}

extension TweetCellViewModel {
    private func buildAttributedText(from content: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: content)

        let mentionMatches = matchMentions(from: content)
        for match in mentionMatches {
            attributedString.addAttributes(
                [
                    .foregroundColor: UIColor.blue
                ],
                range: match.range
            )
        }

        let linkMatches = matchLinks(from: attributedString)
        for match in linkMatches {
            attributedString.addAttributes(
                [
                    .foregroundColor: UIColor.blue,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ],
                range: match.range
            )
        }
        
        return attributedString
    }
    
    private func matchMentions(from content: String) -> [NSTextCheckingResult] {
        let mentionRegex = try? NSRegularExpression(pattern: "@\\w+")
        let match = mentionRegex?.matches(
            in: content,
            range: NSRange(
                location: 0,
                length: content.count
            )
        )
        return match ?? []
    }
    
    private func matchLinks(from attributedString: NSMutableAttributedString) -> [NSTextCheckingResult] {
        guard let linkDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return []
        }
        let match = linkDetector.matches(
            in: attributedString.string,
            range: NSRange(
                location: 0,
                length: attributedString.length
            )
        )
        return match
    }
}
