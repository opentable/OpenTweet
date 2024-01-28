//
//  TweetReplyView.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-27.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol TweetReplyViewConfiguring {
    var mainTweetViewConfigurer: TweetViewConfiguring { get }
    var replyTweetViewConfigurer: TweetViewConfiguring? { get }
}

final class TweetReplyView: UIView {
    private lazy var mainTweetView: TweetView = {
        let view = TweetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var replyIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrowshape.turn.up.left.fill")
//        imageView.image?.withTintColor(.white)
//        imageView.tintColor = Constants.Colors.dynamicTextColor
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var replyTweetView: TweetView = {
        let view = TweetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray.withAlphaComponent(0.4)
        view.isHidden = true
        return view
    }()
    
    func configureViews(configurer: TweetReplyViewConfiguring) {
        backgroundColor = UIColor(Constants.Colors.backgroundColor)
        makeRoundedCornerOfRadius(radius: 10)
        mainTweetView.configureViews(configurer: configurer.mainTweetViewConfigurer)
        if let configurer = configurer.replyTweetViewConfigurer {
            replyIconImageView.isHidden = false
            replyTweetView.configureViews(configurer: configurer)
            replyTweetView.isHidden = false
        } else {
            mainTweetView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Dimens.screenPadding / 2).isActive = true
        }
    }
    
    func reset() {
        mainTweetView.reset()
        replyTweetView.reset()
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TweetReplyView {
    func commonInit() {
        addSubviews()
        layoutConstraints()
    }
    
    func addSubviews() {
        addSubview(mainTweetView)
        addSubview(replyIconImageView)
        addSubview(replyTweetView)
    }
    
    func layoutConstraints() {
        let constraints: [NSLayoutConstraint] = [
            mainTweetView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Dimens.screenPadding / 2),
            mainTweetView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Dimens.screenPadding / 2),
            mainTweetView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Dimens.screenPadding),
            
            replyIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Dimens.screenPadding),
            replyIconImageView.topAnchor.constraint(equalTo: mainTweetView.bottomAnchor, constant: Constants.Dimens.screenPadding / 2),
            replyIconImageView.widthAnchor.constraint(equalToConstant: Constants.Dimens.imageSizeSmall.width),
            replyIconImageView.heightAnchor.constraint(equalToConstant: Constants.Dimens.imageSizeSmall.height),
            
            replyTweetView.leadingAnchor.constraint(equalTo: replyIconImageView.trailingAnchor, constant: Constants.Dimens.screenPadding / 2),
            replyTweetView.topAnchor.constraint(equalTo: mainTweetView.bottomAnchor, constant: Constants.Dimens.screenPadding / 2),
            replyTweetView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Dimens.screenPadding),
            replyTweetView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Dimens.screenPadding),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
