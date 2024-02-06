//
//  Constants.swift
//  OpenTweet
//
//  Created by Jesper Rage on 2024-02-04.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit


// Colours
// Dark Colour Scheme
let theme = AppTheme(
    textTitle: UIColor(hexString: "E7E7E7"),
    textBody: UIColor(hexString: "DEDEDE"),
    textHighlight: UIColor(hexString: "4A9AE7"),
    background: .black,
    forground: .black,
    trim: UIColor(hexString: "727272"),
    
    //Fonts
    titleFont: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold),
    bodyFont:  UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular),
    replyFont: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
    dateFont:  UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular),
    replyCountFont: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular))

// Data locations
let timelineFileName = "timeline"

// Variable
let timelineOrder = TimelineOrder.oldestToLatest
