//
//  TweetTableViewCell.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol ImageReloader {
    func update(with: UIImage)
}

class TweetTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TweetViewCell"

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private var viewModel: TweetViewCellPresenter!

    func setup(with cellData: TweetViewCellData) {
        viewModel = TweetViewCellPresenter(cellData: cellData)
        setupViews()
        cellData.loadAvatarImage(self)
    }

    private func setupViews() {
        avatarImageView.image = viewModel.avatarImage
        authorLabel.text = viewModel.author
        tweetLabel.attributedText = viewModel.content
        dateLabel.text = viewModel.date
    }
}

extension TweetTableViewCell: ImageReloader {
    func update(with newImage: UIImage) {
        DispatchQueue.main.async {
            self.avatarImageView.image = newImage
        }
    }
}
