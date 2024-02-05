//
//  TweetViewCellPresenter.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class TweetViewCellPresenter {

    private var cellData: TweetViewCellData

    init(cellData: TweetViewCellData) {
        self.cellData = cellData
    }

    var author: String {
        cellData.author
    }
    
    var avatarImage: UIImage? {
        if let image = cellData.avatarImage {
            return image
        }
        return UIImage(systemName: "person.circle")
    }

    var content: NSAttributedString {
        return TweetParser().generateContent(from: cellData.content)
    }

    var date: String {
        Self.format(cellData.date)
    }

    private static func format(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: date)
    }
}
