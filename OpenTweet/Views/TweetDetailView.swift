//
//  TweetDetailView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct TweetDetailView: View {
    @EnvironmentObject private var viewModel: TweetDetailViewModel
    let tweet: Tweet

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
                    HighlightTweetText(content: tweet.content)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(DisplayConstants.Sizes.padding)
                        .font(.headline)
                        .background(DisplayConstants.Colors.backgroundColor)
                        .cornerRadius(DisplayConstants.Sizes.cornerRadius)
                    Text(tweet.formattedDate()).font(.subheadline)
                }
                .cornerRadius(DisplayConstants.Sizes.cornerRadius)
                switch viewModel.data {
                    case .loading:
                        ProgressView()
                    case .loaded(let replies):
                    if !replies.isEmpty {
                        Divider()
                        TweetReplyView(replies: replies)
                    }
                    case .error:
                        Text("Error")
                }
            }
            .padding(DisplayConstants.Sizes.largePadding)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    ProfilePicture(user: tweet.toUser(), size: DisplayConstants.Sizes.imageSizeSmall)
                    Text(tweet.author).font(.subheadline)
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TweetDetailView(tweet: PreviewConstants.tweet).environmentObject(TweetDetailViewModel(tweet: PreviewConstants.tweet))
    }
}
