//
//  TweetRepliesView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

struct TweetRepliesView: View {
    @EnvironmentObject private var viewModel: TweetRepliesViewModel
    let small: Bool

    func repliesList(replies: [Tweet]) -> some View {
        VStack {
            ForEach(replies, id: \.id) {
                TweetRepliesView(small: false)
                    .environmentObject(TweetRepliesViewModel(tweet: $0, depth: viewModel.depth + 1))
                    .cellStyling
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
            NavigationLink(value: viewModel.tweet) {
                if small {
                    TweetCellSmall(tweet: viewModel.tweet)
                } else {
                    TweetCell(tweet: viewModel.tweet)
                }
            }.buttonStyle(.plain)
            switch viewModel.data {
            case .loading:
                ProgressView()
            case .loaded(let replies):
                if !replies.isEmpty {
                    if viewModel.depth > 0 {
                        HStack(alignment: .top, spacing: DisplayConstants.Sizes.padding) {
                            DisplayConstants.Images.rightArrow
                                .foregroundStyle(DisplayConstants.Colors.accentColor)
                            repliesList(replies: replies)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
                            Text(LocalizableStrings.replies.stringValue).font(.headline)
                            repliesList(replies: replies)
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
}

#Preview {
    NavigationStack {
        TweetRepliesView(small: false)
            .environmentObject(TweetRepliesViewModel(tweet: PreviewConstants.tweet, depth: 0))
    }
}
