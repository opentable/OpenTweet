//
//  UIButton+Extensions.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/18/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

extension UIButton {
    func configureUsernameButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(K.Colors.mainAppColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.001, bottom: 0.001, right: 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }
}
