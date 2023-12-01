//
//  TweetCell.swift
//  OpenTweetUIKit
//
//  Created by Landon Rohatensky on 2023-11-09.
//  Copyright © 2023 OpenTable, Inc. All rights reserved.
//

import UIKit

class TweetCard: UIView {
    private let headerView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .darkGray
        return contentView
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.layer.cornerRadius = DisplayConstants.Sizes.cornerRadius
        contentView.backgroundColor = UIColor(DisplayConstants.Colors.backgroundColor)
        contentView.clipsToBounds = true
        return contentView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(
            top: DisplayConstants.Sizes.padding,
            left: DisplayConstants.Sizes.padding,
            bottom: DisplayConstants.Sizes.padding,
            right: 0
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        return stackView
    }()

    private let headerTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: DisplayConstants.Sizes.padding,
            bottom: 0,
            right: DisplayConstants.Sizes.padding
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = DisplayConstants.Colors.dynamicTextColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = DisplayConstants.Colors.dynamicTextColor
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = DisplayConstants.Colors.dynamicTextColor
        return label
    }()

    private let mainImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setWidthConstraint(48)
        imageView.anchorAspectRatio()
        imageView.layer.cornerRadius = 24
        imageView.backgroundColor = UIColor(DisplayConstants.Colors.backgroundColor)
        return imageView
    }()

    private func setupContentView() {
        addSubview(contentView)
        contentView.pin(
            superView: self,
            topMargin: DisplayConstants.Sizes.padding,
            leftMargin: DisplayConstants.Sizes.padding,
            bottomMargin: DisplayConstants.Sizes.padding,
            rightMargin: DisplayConstants.Sizes.padding
        )
        contentView.addSubview(contentStackView)
        contentStackView.pin(superView: contentView)
    }

    private func setupTextStackView() {
        headerStackView.addArrangedSubview(headerTextStackView)
        headerTextStackView.addArrangedSubview(authorLabel)
        headerTextStackView.addArrangedSubview(dateLabel)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        contentStackView.addArrangedSubview(headerStackView)
        headerStackView.addArrangedSubview(mainImageView)
        setupTextStackView()
        contentStackView.addArrangedSubview(contentLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setImage(urlString: String) {
        Task {
            do {
                if let url = URL(string: urlString) {
                    let image = try? await ImageService.shared.getImage(url: url)
                    DispatchQueue.main.async { [weak mainImageView] in
                        mainImageView?.image = image
                    }
                }
            }
        }
    }

    func configure(tweet: Tweet) {
        authorLabel.text = tweet.author
        dateLabel.text = DateUtils.formatTimeAgo(from: tweet.date)
        if let avatar = tweet.avatar {
            setImage(urlString: avatar)
        }
        let tweetMatch = AttributedTweetStringMatch(content: tweet.content)
        for match in tweetMatch.mentionMatches {
            tweetMatch.attributedString.addAttributes([.foregroundColor: DisplayConstants.Colors.accentColor.safeCGColor], range: match.range)
        }
        for linkMatch in tweetMatch.linkMatches {
            tweetMatch.attributedString.addAttributes([
                .foregroundColor: DisplayConstants.Colors.accentColor.safeCGColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: linkMatch.range)
        }
        contentLabel.attributedText = tweetMatch.attributedString
    }

    func reset() {
        mainImageView.image = nil
    }
}

class TweetCell: UICollectionViewCell {
    static let identifier: String = "TweetCell"

    private let view = TweetCard()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view)
        view.pin(superView: self)
        backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        view.reset()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ tweet: Tweet) {
        view.configure(tweet: tweet)
    }
}
