//
//  TweetRepliesView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

struct TweetRepliesView: View {
    @EnvironmentObject private var viewModel: TweetRepliesViewModel
    @Binding var tweetToNavigate: Tweet?
    @Binding var userToNavigate: User?

    func repliesList(replies: [Tweet]) -> some View {
        VStack {
            ForEach(replies, id: \.id) {
                TweetRepliesView(
                    tweetToNavigate: $tweetToNavigate,
                    userToNavigate: $userToNavigate
                ).environmentObject(TweetRepliesViewModel(tweet: $0, depth: viewModel.depth + 1))
                    .cellStyling
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
            TweetCell(
                tweet: viewModel.tweet,
                tweetToNavigate: $tweetToNavigate,
                userToNavigate: $userToNavigate
            )
            switch viewModel.data {
            case .loading:
                ProgressView()
            case .loaded(let replies):
                if !replies.isEmpty {
                    HStack(spacing: DisplayConstants.Sizes.padding) {
                        Image(systemName: DisplayConstants.rightArrowName)
                            .foregroundStyle(DisplayConstants.Colors.accentColor)
                        repliesList(replies: replies)
                            .background(.clear)
                    }
                    .background(.clear)
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
    TweetRepliesView(
        tweetToNavigate: .constant(nil),
        userToNavigate: .constant(nil)
    ).environmentObject(TweetRepliesViewModel(tweet: PreviewConstants.tweet, depth: 0))
}
