//
//  DisplayConstants.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

enum DisplayConstants {
    enum Sizes {
        static let padding: CGFloat = 8
        static let largePadding: CGFloat = 16
        static let cornerRadius: CGFloat = 10
        static let imageSizeMedium = CGSize(width: 48, height: 48)
        static let imageSizeSmall = CGSize(width: 32, height: 32)
        static let imageSizeLarge = CGSize(width: 96, height: 96)
    }

    enum Colors {
        static let backgroundColor = Color.gray.opacity(0.2)
        static let accentColor = Color.accentColor
        static let textColor = Color.primary
        static let dynamicTextColor = Color.dynamicColor(light: .black, dark: .white)
    }

    enum Images {
        static let rightArrow: Image = Image(systemName: "arrowshape.turn.up.right.fill")
        static let person: Image = Image(systemName: "person.circle")
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
            case .dark: return dark
            default: return light
            }
        }
    }
}
