//
//  TweetView.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol TweetViewConfiguring {
    var authorLabelConfigurer: LabelViewConfiguring { get }
    var authorImageUrl: String? { get }
    var contentLabelConfigurer: LabelViewConfiguring { get }
    var dateLabelConfigurer: LabelViewConfiguring { get }
}

final class TweetView: UIView {
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(Constants.Colors.backgroundColor)
        return imageView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    func configureViews(configurer: TweetViewConfiguring) {
        backgroundColor = UIColor(Constants.Colors.backgroundColor)
        makeRoundedCornerOfRadius(radius: 10)
        authorLabel.setup(configurer: configurer.authorLabelConfigurer)
        if let url = configurer.authorImageUrl {
            authorImageView.loadImageFromURL(urlString: url)
        } else {
            authorImageView.image = AvatarGenerator.generateAvatarImage(
                forUsername: authorLabel.text ?? "",
                size: Constants.Dimens.imageSizeMedium
            )
        }
        authorImageView.makeRoundedCornerOfRadius(radius: Constants.Dimens.imageSizeMedium.width / 2)
        contentLabel.setup(configurer: configurer.contentLabelConfigurer)
        if let contentText = configurer.contentLabelConfigurer.text {
            let attributedStringBuilder = AttributedStringBuilder(string: contentText)
            for match in attributedStringBuilder.linkMatches {
                attributedStringBuilder.attributedString.addAttributes(
                    [
                        .foregroundColor: Constants.Colors.accentColor.safeCGColor,
                        .underlineStyle: NSUnderlineStyle.single.rawValue
                    ],
                    range: match.range
                )
            }
            for match in attributedStringBuilder.mentionMatches {
                attributedStringBuilder.attributedString.addAttributes(
                    [
                        .foregroundColor: Constants.Colors.accentColor.safeCGColor
                    ],
                    range: match.range
                )
            }
            contentLabel.attributedText = attributedStringBuilder.attributedString
        }
        dateLabel.setup(configurer: configurer.dateLabelConfigurer)
    }
    
    func reset() {
        authorImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TweetView {
    func commonInit() {
        addSubviews()
        layoutConstraints()
    }
    
    func addSubviews() {
        addSubview(headerView)
        headerView.addSubview(authorImageView)
        headerView.addSubview(headerTextStackView)
        headerTextStackView.addArrangedSubview(authorLabel)
        headerTextStackView.addArrangedSubview(dateLabel)
        addSubview(contentLabel)
    }
    
    func layoutConstraints() {
        let constraints: [NSLayoutConstraint] = [
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            authorImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.Dimens.screenPadding),
            authorImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: Constants.Dimens.screenPadding),
            authorImageView.widthAnchor.constraint(equalToConstant: Constants.Dimens.imageSizeMedium.width),
            authorImageView.heightAnchor.constraint(equalToConstant: Constants.Dimens.imageSizeMedium.height),
            authorImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -Constants.Dimens.screenPadding),
            
            headerTextStackView.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: Constants.Dimens.screenPadding / 2),
            headerTextStackView.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor),
            headerTextStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
           
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Dimens.screenPadding),
            contentLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.Dimens.screenPadding / 4),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Dimens.screenPadding),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Dimens.screenPadding),
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
