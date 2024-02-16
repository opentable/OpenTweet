//
//  Replacer.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-06.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol Replacer {
    var id: Character { get }
    var lookFor: String { get }
    func getAttributes(value: String) -> [NSAttributedString.Key: Any]
}

struct MentionReplacer: Replacer {
    var id = Character("@")
    var lookFor = "@"
    func getAttributes(value: String) -> [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
    }
}

struct URLReplacer: Replacer {
    var id = Character("h")
    var lookFor = "https"
    var url: String?
    func getAttributes(value: String) -> [NSAttributedString.Key : Any] {
        return [.link: URL(string: value)!]
    }
}
