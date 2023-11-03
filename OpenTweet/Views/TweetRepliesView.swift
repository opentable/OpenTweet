//
//  TweetRepliesView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

struct TweetRepliesView: View {
    @EnvironmentObject private var viewModel: TweetRepliesViewModel

    func repliesList(replies: [Tweet]) -> some View {
        VStack {
            ForEach(replies, id: \.id) {
                TweetRepliesView()
                    .environmentObject(TweetRepliesViewModel(tweet: $0, depth: viewModel.depth + 1))
                    .cellStyling
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
            NavigationLink(value: viewModel.tweet) {
                TweetCell(
                    tweet: viewModel.tweet
                )
            }.buttonStyle(.plain)
            switch viewModel.data {
            case .loading:
                ProgressView()
            case .loaded(let replies):
                if !replies.isEmpty {
                    HStack(spacing: DisplayConstants.Sizes.padding) {
                        Image(systemName: DisplayConstants.rightArrowName)
                            .foregroundStyle(DisplayConstants.Colors.accentColor)
                        repliesList(replies: replies)
                    }
                }
            case .error:
                Text(LocalizableStrings.error.stringValue)
            case .maxDepth:
                EmptyView()
            }
        }
    }
}

#Preview {
    TweetRepliesView()
        .environmentObject(TweetRepliesViewModel(tweet: PreviewConstants.tweet, depth: 0))
}
