//
//  TweetDetailView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct TweetDetailView: View {
    let tweet: Tweet

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
                    TweetCellSmall(tweet: tweet)
                }.cellStyling
                TweetParentRepliesView()
                    .environmentObject(TweetRepliesViewModel(tweet: tweet))
            }
            .padding(DisplayConstants.Sizes.largePadding)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                NavigationLink(value: tweet.toUser()) {
                    HStack {
                        ProfilePicture(user: tweet.toUser(), size: DisplayConstants.Sizes.imageSizeSmall)
                        Text(tweet.author)
                            .font(.subheadline)
                    }
                }.buttonStyle(.plain)
            }}
        .navigationTitle(tweet.content)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TweetDetailView(tweet: PreviewConstants.replyTweet)
    }
}
