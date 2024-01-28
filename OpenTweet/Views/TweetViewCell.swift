//
//  TweetViewCell.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

final class TweetViewCell: UICollectionViewCell {
    static let identifier: String = "TweetViewCell"

    private let view = TweetView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view)
        view.pinToSuperView()
        backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        view.reset()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(tweetConfigurer: TweetViewConfiguring) {
        view.configureViews(configurer: tweetConfigurer)
    }
}
