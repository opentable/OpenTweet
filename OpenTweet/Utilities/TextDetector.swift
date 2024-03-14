//
//  TextDetector.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol TextPatternDetector {
  func matches(in string: String) -> [NSTextCheckingResult]
}

struct MentionDetector: TextPatternDetector {
  func matches(in string: String) -> [NSTextCheckingResult] {
    let pattern = "@\\w+"
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
    return regex.matches(in: string, range: NSRange(location: 0, length: string.utf16.count))
  }
}

struct LinkDetector: TextPatternDetector {
  func matches(in string: String) -> [NSTextCheckingResult] {
    guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return [] }
    return detector.matches(in: string, range: NSRange(location: 0, length: string.utf16.count))
  }
}

struct AttributedStringBuilder {
  var attributedString: NSMutableAttributedString
  var detectors: [TextPatternDetector] = [MentionDetector(), LinkDetector()]
  
  init(string: String) {
    attributedString = NSMutableAttributedString(string: string)
  }
}
