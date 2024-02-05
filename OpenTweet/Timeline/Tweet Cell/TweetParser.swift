//
//  TweetParser.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-06.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

struct TweetParser {

    private var replacements: [Character: Replacer]

    init() {
        replacements = Self.replacerSetup()
    }

    private static func replacerSetup() -> [Character: Replacer] {
        var replacements = [Character: Replacer]()
        let mentionReplacer = MentionReplacer()
        replacements[mentionReplacer.id] = mentionReplacer
        
        let urlReplacer = URLReplacer()
        replacements[urlReplacer.id] = urlReplacer

        return replacements
    }
    
    func generateContent(from content: String) -> NSAttributedString {
        let strings = NSMutableAttributedString(string: "")
        var content = content

        var notHighlighted = [Character]()
        while let char = content.first {
            if let replacement = replacements[char],
               let index = content.range(of: replacement.lookFor)?.lowerBound {

                if !notHighlighted.isEmpty {
                    strings.append(NSAttributedString(string: String(notHighlighted)))
                    notHighlighted.removeAll()
                }

                var replace = ""
                if let space = content[index...].firstIndex(of: " ") {
                    replace = String(content[index..<space])
                    content = String(content[space...])
                } else {
                    replace = String(content[index...])
                    strings.append(NSAttributedString(string: String(content[..<index])))
                    content = ""
                }

                let replacedString = NSAttributedString(string: replace, attributes: replacement.getAttributes(value: replace))
                strings.append(replacedString)
            } else {
                notHighlighted.append(char)
                if !content.isEmpty {
                    _ = content.removeFirst()
                }
            }
        }

        if !notHighlighted.isEmpty {
            strings.append(NSAttributedString(string: String(notHighlighted)))
        }

        return strings
    }
}
