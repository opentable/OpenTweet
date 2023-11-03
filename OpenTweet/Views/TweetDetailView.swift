//
//  TweetDetailView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct TweetDetailView: View {
    @EnvironmentObject private var viewModel: TweetDetailViewModel

    func replyToView(replyTo: Tweet) -> some View {
        NavigationLink(value: replyTo) {
            VStack(alignment: .leading) {
                Text(LocalizableStrings.inReplyTo.stringValue).font(.headline)
                VStack {
                    TweetCell(
                        tweet: replyTo
                    )}.padding(DisplayConstants.Sizes.padding)
                    .background(DisplayConstants.Colors.backgroundColor)
                    .cornerRadius(DisplayConstants.Sizes.cornerRadius)
            }
        }.buttonStyle(.plain)
    }

    var headerView: some View {
        VStack(spacing: DisplayConstants.Sizes.padding) {
            HighlightTweetText(content: viewModel.tweet.content)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(DateUtils.formatTimeAgo(from: viewModel.tweet.date))
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
                    headerView
                    switch viewModel.data {
                    case .loading:
                        ProgressView()
                    case .loaded(let replyTo):
                        if let replyTo = replyTo {
                            replyToView(replyTo: replyTo)
                        }
                    case .error:
                        Text(LocalizableStrings.error.stringValue)
                    }
                }.cellStyling
                TweetParentRepliesView()
                    .environmentObject(TweetRepliesViewModel(tweet: viewModel.tweet))
            }
            .padding(DisplayConstants.Sizes.largePadding)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                NavigationLink(value: viewModel.tweet.toUser()) {
                    HStack {
                        ProfilePicture(user: viewModel.tweet.toUser(), size: DisplayConstants.Sizes.imageSizeSmall)
                        Text(viewModel.tweet.author).font(.subheadline)
                    }
                }.buttonStyle(.plain)
            }}
        .navigationTitle(viewModel.tweet.content)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TweetDetailView(
        ).environmentObject(TweetDetailViewModel(tweet: PreviewConstants.replyTweet))
    }
}
