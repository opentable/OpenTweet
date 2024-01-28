//
//  Constants.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import SwiftUI

enum Constants {
    enum Dimens {
        static let screenPadding: CGFloat = 16
        static let imageSizeSmall = CGSize(width: 24, height: 24)
        static let imageSizeNavigationBar = CGSize(width: 44, height: 44)
        static let imageSizeMedium = CGSize(width: 48, height: 48)
    }
    enum Colors {
        static let backgroundColor = Color.gray.opacity(0.2)
        static let accentColor = Color.accentColor
        static let textColor = Color.primary
        static let dynamicTextColor = Color.dynamicColor(light: .black, dark: .white)
    }

    static let appTitle = "OpenTweet"
    static let dateFormat = "MMMM d, yyyy 'at' h:mm a"
}

extension Color {
    var safeCGColor: CGColor {
        UIColor(self).cgColor
    }

    public static func dynamicColor(
        light: UIColor,
        dark: UIColor) -> UIColor {

        return UIColor {
            switch $0.userInterfaceStyle {
            case .dark: 
                return dark
            default: 
                return light
            }
        }
    }
}
