//
//  ViewExtensions.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

extension View {
    var cellStyling: some View {
        self
            .padding(DisplayConstants.Sizes.padding)
            .background(DisplayConstants.Colors.backgroundColor)
            .cornerRadius(DisplayConstants.Sizes.cornerRadius)
    }
}
