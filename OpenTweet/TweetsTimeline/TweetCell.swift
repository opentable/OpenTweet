//
//  TweetCell.swift
//  OpenTweet
//
//  Created by Iryna Rivera on 5/19/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak private var author: UILabel!
    @IBOutlet weak private var content: UITextView!
    @IBOutlet weak private var date: UILabel!
    
    func update(_ tweet: TweetInfo) {
        self.author.text = tweet.author
        self.content.text = tweet.content
        self.date.text = tweet.date
    }
    
    func editDateFormat() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let myDate = dateFormatter.date(from: date.text!)!

        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date = dateFormatter.string(from: myDate)
        self.date.text = date
    }
}
