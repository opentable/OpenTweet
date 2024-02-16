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

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private var viewModel: TweetViewCellPresenter!

    func setup(with cellData: TweetViewCellData, isSelected: Bool) {
        viewModel = TweetViewCellPresenter(cellData: cellData)
        setupViews(isSelected)
        cellData.loadAvatarImage(self)
    }

    private func setupViews(_ isSelected: Bool) {
        avatarImageView.image = viewModel.avatarImage
        authorLabel.text = viewModel.author
        tweetLabel.attributedText = viewModel.content
        dateLabel.text = viewModel.date

        setupBorder(isSelected)
    }

    private func setupBorder(_ highlight: Bool) {
        if highlight {
            layer.borderColor = UIColor.blue.cgColor
            layer.borderWidth = 1
        } else {
            layer.borderWidth = 0
        }
    }
}

extension TweetTableViewCell: ImageReloader {
    func update(with newImage: UIImage) {
        DispatchQueue.main.async {
            self.avatarImageView.image = newImage
        }
    }
}
