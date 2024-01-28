//
//  LabelViewConfiguring.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

/// Protocol used to configure UILabel
protocol LabelViewConfiguring {
    /// The label's text
    var text: String? { get }

    /// The label's font
    var font: UIFont? { get }

    /// The label's text color
    var textColor: UIColor? { get }
    
    /// The number of lines a label should have
    var numberOfLines: Int? { get }
}

final class LabelViewModel: LabelViewConfiguring {
    let text: String?
    let font: UIFont?
    let textColor: UIColor?
    let numberOfLines: Int?
    
    init(text: String?, 
         font: UIFont?,
         textColor: UIColor?,
         numberOfLines: Int?) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}
