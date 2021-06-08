//
//  UITextView+Extensions.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/18/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

extension UITextView {
    func highlightMentions() {
        // Separate text into array of strings
        let words: [String] = self.text.components(separatedBy: " ")
        
        let attributedString = NSMutableAttributedString()
        attributedString.setAttributedString(self.attributedText)
        
        // Loop through array of words looking for @username mentions
        for word in words {
            if word.hasPrefix("@") {
                let range = (word as NSString).range(of: word)
                // Make the word the app's main color
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: K.Colors.mainAppColor, range: range)
            }
        }
        self.attributedText = attributedString
    }
    
    func configureContentTextView(fontSize: CGFloat = 16) -> UITextView {
        let tv = UITextView()
        tv.textColor = K.Colors.black
        tv.automaticallyAdjustsScrollIndicatorInsets = false
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = false
        tv.isUserInteractionEnabled = false
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: fontSize)
        tv.textContainer.lineFragmentPadding = 0
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tv
    }
}
