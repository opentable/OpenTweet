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
        static let imageSize = CGSize(width: 48, height: 48)
        static let imageSizeSmall = CGSize(width: 32, height: 32)
    }

    enum Colors {
        static let backgroundColor = Color.gray.opacity(0.2)
        static let accentColor = Color.accentColor
        static let textColor = Color.primary
    }

    static let appTitle = "OpenTweet"
    static let rightArrowName = "arrowshape.turn.up.right.fill"
    static let dateFormat = "MMMM d, yyyy 'at' h:mm a"
}
