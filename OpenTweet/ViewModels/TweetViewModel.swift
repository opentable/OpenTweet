//
//  TweetViewModel.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

final class TweetViewModel: TweetViewConfiguring {
    let authorLabelConfigurer: LabelViewConfiguring
    
    let authorImageUrl: String?
    
    let contentLabelConfigurer: LabelViewConfiguring
    
    let dateLabelConfigurer: LabelViewConfiguring
    
    init(tweet: Tweet) {
        authorLabelConfigurer = LabelViewModel(
            text: tweet.author,
            font: .boldSystemFont(ofSize: 16),
            textColor: Constants.Colors.dynamicTextColor,
            numberOfLines: 1
        )
        
        authorImageUrl = tweet.avatar
        
        contentLabelConfigurer = LabelViewModel(
            text: tweet.content,
            font: .systemFont(ofSize: 12),
            textColor: Constants.Colors.dynamicTextColor,
            numberOfLines: 0
        )
        dateLabelConfigurer = LabelViewModel(
            text: DateUtils.formatTimeAgo(from: tweet.getDateFromTweet()),
            font: .systemFont(ofSize: 12),
            textColor: Constants.Colors.dynamicTextColor,
            numberOfLines: 1
        )
    }
}
