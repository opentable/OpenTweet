//
//  AppTheme.swift
//  OpenTweet
//
//  Created by Jesper Rage on 2024-02-04.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

// Todo impilment options
enum ColourMode:String {
    case light = "Light Mode"
    case dark = "Dark Mode"
    case os = "Match OS"
}


// Todo make struct with getters and setters that access user defaults
struct AppTheme {
    let textTitle: UIColor
    let textBody: UIColor
    let textHighlight: UIColor
    let background: UIColor
    let forground: UIColor
    let trim: UIColor
    
    let titleFont: UIFont
    let bodyFont: UIFont
    let replyFont: UIFont
    let dateFont: UIFont
    let replyCountFont: UIFont
}

