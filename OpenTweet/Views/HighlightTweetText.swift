//
//  HighlightTweetText.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct HighlightTweetText: View {
    let content: String?
    var accentColor: Color = DisplayConstants.Colors.accentColor
    var textColor: Color = DisplayConstants.Colors.textColor
    private(set)var linkCount = 0

    func highlightedText(tweetMatch: AttributedTweetStringMatch) -> Text {
        let stringRange = NSRange(location: 0, length: tweetMatch.attributedString.length)

        var text = Text("")
        tweetMatch.attributedString.enumerateAttributes(in: stringRange, options: []) { _, range, _ in
            let substring = tweetMatch.attributedString.attributedSubstring(from: range)
            var attributedSubstring = AttributedString(substring)
            let linkMatch: Bool = tweetMatch.linkMatches.first(where: { NSRange(location: $0.range.location, length: $0.range.length) == range }) != nil
            let mentionMatch: Bool = (tweetMatch.mentionMatches.first(where: { NSRange(location: $0.range.location, length: $0.range.length) == range })) != nil
            if linkMatch {
                attributedSubstring.link = URL(string: substring.string)
                text = text + Text(attributedSubstring)
                    .foregroundColor(accentColor)
                    .underline()
            } else if mentionMatch {
                text = text + Text(attributedSubstring)
                    .foregroundColor(accentColor)
            } else {
                text = text + Text(attributedSubstring)
                    .foregroundColor(textColor)
            }
        }

        return text
    }

    var body: some View {
        guard let content = content else {
            return Text("")
        }
        let tweetMatch = AttributedTweetStringMatch(content: content)
        for match in tweetMatch.mentionMatches {
            tweetMatch.attributedString.addAttributes([.foregroundColor: accentColor], range: match.range)
        }
        for linkMatch in tweetMatch.linkMatches {
            tweetMatch.attributedString.addAttributes([
                .foregroundColor: accentColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: linkMatch.range)
        }

        return highlightedText(tweetMatch: tweetMatch)
    }
}

#Preview {
    HighlightTweetText(content: PreviewConstants.tweet.content)
}
