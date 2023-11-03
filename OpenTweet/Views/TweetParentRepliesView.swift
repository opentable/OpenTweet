//
//  TweetParentRepliesView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

struct TweetParentRepliesView: View {
    @EnvironmentObject private var viewModel: TweetRepliesViewModel
    @Binding var tweetToNavigate: Tweet?
    @Binding var userToNavigate: User?

    var body: some View {
        switch viewModel.data {
        case .loading:
            ProgressView()
        case .loaded(let replies):
            if !replies.isEmpty {
                Divider()
                Text(LocalizableStrings.replies.stringValue).font(.headline)
                VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
                    ForEach(replies, id: \.id) {
                        TweetRepliesView(
                            tweetToNavigate: $tweetToNavigate,
                            userToNavigate: $userToNavigate
                        ).environmentObject(
                            TweetRepliesViewModel(
                                tweet: $0,
                                depth: viewModel.depth + 1)
                        ).cellStyling
                    }
                }
            }
        case .error:
            Text(LocalizableStrings.error.stringValue)
        case .maxDepth:
            EmptyView()
        }
    }
}

#Preview {
    TweetRepliesView(
        tweetToNavigate: .constant(nil),
        userToNavigate: .constant(nil)
    ).environmentObject(TweetRepliesViewModel(tweet: PreviewConstants.tweet, depth: 0))
}
