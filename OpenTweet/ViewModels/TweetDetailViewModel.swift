//
//  TweetDetailViewModel.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-27.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

final class TweetDetailViewModel: NSObject, TweetDetailViewConfiguring {
    let mainTweetViewConfigurer: TweetViewConfiguring
    
    let dividerLabelConfigurer: LabelViewConfiguring?
    
    var collectionViewLayout: UICollectionViewLayout = {
        let estimatedHeight: CGFloat = 100
        let width: NSCollectionLayoutDimension = .fractionalWidth(1)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: width,
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: width,
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    init(tweet: Tweet) {
        mainTweetViewConfigurer = TweetViewModel(tweet: tweet)
        if tweet.tweetReplies.isEmpty {
            dividerLabelConfigurer = nil
        } else {
            dividerLabelConfigurer = LabelViewModel(
                text: "Replies",
                font: .boldSystemFont(ofSize: 16),
                textColor: Constants.Colors.dynamicTextColor, numberOfLines: 1
            )
        }
    }
}
