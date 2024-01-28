//
//  TweetDetailView.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-27.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol TweetDetailViewConfiguring {
    var mainTweetViewConfigurer: TweetViewConfiguring { get }
    var dividerLabelConfigurer: LabelViewConfiguring? { get }
    var collectionViewLayout: UICollectionViewLayout { get }
}

enum TweetDetailSection {
    case mainTweet
    case replyToTweet
    case tweetReplies
}

final class TweetDetailView: UIView {
    private lazy var mainTweetView: TweetView = {
        let view = TweetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configureViews(configurer: configurer.mainTweetViewConfigurer)
        return view
    }()
    
    private lazy var dividerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let configurer = configurer.dividerLabelConfigurer {
            label.setup(configurer: configurer)
        } else {
            label.isHidden = true
        }
        return label
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configurer.collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(TweetReplyCell.self, forCellWithReuseIdentifier: TweetReplyCell.identifier)
        return collectionView
    }()
    
    private let configurer: TweetDetailViewConfiguring
    
    init(configurer: TweetDetailViewConfiguring) {
        self.configurer = configurer
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TweetDetailView {
    func commonInit() {
        addSubviews()
        layoutConstraints()
    }
    
    func addSubviews() {
        addSubview(mainTweetView)
        addSubview(dividerLabel)
        addSubview(collectionView)
    }
    
    func layoutConstraints() {
        let constraints: [NSLayoutConstraint] = [
            mainTweetView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Dimens.screenPadding),
            mainTweetView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Dimens.screenPadding),
            mainTweetView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Dimens.screenPadding),
            
            dividerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Dimens.screenPadding),
            dividerLabel.topAnchor.constraint(equalTo: mainTweetView.bottomAnchor, constant: Constants.Dimens.screenPadding),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Dimens.screenPadding),
            collectionView.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: Constants.Dimens.screenPadding),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Dimens.screenPadding),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Dimens.screenPadding)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
