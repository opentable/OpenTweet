//
//  AvatarGenerator.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-27.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

enum AvatarGenerator {
    static func generateAvatarImage(forUsername username: String, size: CGSize, backgroundColor: UIColor = UIColor.systemGray, textColor: UIColor = UIColor.white) -> UIImage {
        let name = username.replacingOccurrences(of: "@", with: "") // Remove the "@" character from the username
        let firstCharacter = String(name.prefix(1)).uppercased()
        
        let frame = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        // Fill background color
        backgroundColor.setFill()
        UIRectFill(frame)
        
        // Draw text (first letter of the name) in the center
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: size.width * 0.4),
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let textSize = firstCharacter.size(withAttributes: attributes)
        let textRect = CGRect(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2, width: textSize.width, height: textSize.height)
        firstCharacter.draw(in: textRect, withAttributes: attributes)
        
        // Convert context to image
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            return image
        } else {
            return UIImage() // Return an empty image if drawing fails
        }
    }
}
