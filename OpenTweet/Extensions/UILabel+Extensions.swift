//
//  UILabel+Extensions.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/18/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

extension UILabel {
    func configureTimestampLabel() -> UILabel {
        let label = UILabel()
        label.textColor = K.Colors.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }
}
