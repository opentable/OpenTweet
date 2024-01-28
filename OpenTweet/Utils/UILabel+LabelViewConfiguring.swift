//
//  UILabel+LabelViewConfiguring.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

extension UILabel {
    func setup(configurer: LabelViewConfiguring?) {
        guard let configurer = configurer else {
            return
        }
        self.text = configurer.text
        self.textColor = configurer.textColor
        self.font = configurer.font
        self.numberOfLines = configurer.numberOfLines ?? 1
    }
}
