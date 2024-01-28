//
//  TweetReplyCell.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-27.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

final class TweetReplyCell: UICollectionViewCell {
    static let identifier: String = "TweetReplyCell"

    private let view = TweetReplyView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view)
        view.pinToSuperView()
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view.reset()
    }

    func setup(tweetConfigurer: TweetReplyViewConfiguring) {
        view.configureViews(configurer: tweetConfigurer)
    }
}
