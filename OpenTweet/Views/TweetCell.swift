//
//  TweetCell.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct TweetCell: View {
    let tweet: Tweet
    @Binding var tweetToNavigate: Tweet?
    @Binding var userToNavigate: User?

    var body: some View {
        VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
            HStack {
                ProfilePicture(user: tweet.toUser())
                    .onTapGesture {
                        userToNavigate = tweet.toUser()
                    }
                VStack(alignment: .leading) {
                    Text(tweet.author).font(.subheadline)
                    Text(DateUtils.formatTimeAgo(from: tweet.date)).font(.subheadline)
                }
            }
            HighlightTweetText(content: tweet.content)
                .font(.headline)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onTapGesture {
            print("Selected \(tweet.content)")
            tweetToNavigate = tweet
        }
    }
}

#Preview {
    TweetCell(tweet: PreviewConstants.tweet, tweetToNavigate: .constant(nil), userToNavigate: .constant(nil))
}
