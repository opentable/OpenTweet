//
//  UIColor+Extensions.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/15/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

// MARK: - Custom Color Function

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    // #E03444
    static func mainRed() -> UIColor {
        return UIColor.rgb(red: 224, green: 52, blue: 68)
    }
}
