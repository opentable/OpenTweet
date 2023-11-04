//
//  TweetCellSmall.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

struct TweetCellSmall: View {
    let tweet: Tweet

    var body: some View {
        VStack(spacing: DisplayConstants.Sizes.padding) {
            HighlightTweetText(content: tweet.content)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(DateUtils.formatTimeAgo(from: tweet.date))
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .trailing)
            TweetReplyToView().environmentObject(TweetDetailViewModel(tweet: tweet))
        }
    }
}

#Preview {
    TweetCellSmall(tweet: PreviewConstants.tweet)
}
