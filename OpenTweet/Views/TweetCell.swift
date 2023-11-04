//
//  TweetCell.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct TweetCell: View {
    let tweet: Tweet

    var body: some View {
        VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
            HStack {
                NavigationLink(value: tweet.toUser()) {
                    ProfilePicture(user: tweet.toUser())
                }
                VStack(alignment: .leading) {
                    NavigationLink(value: tweet.toUser()) {
                        Text(tweet.author).font(.subheadline).bold()
                    }
                    Text(DateUtils.formatTimeAgo(from: tweet.date)).font(.subheadline)
                }
            }
            HighlightTweetText(content: tweet.content)
                .font(.headline)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    TweetCell(tweet: PreviewConstants.tweet)
}
