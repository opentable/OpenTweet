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

    func replyToView(replyTo: Tweet) -> some View {
        VStack(alignment: .leading) {
            Text(LocalizableStrings.inReplyTo.stringValue).font(.headline)
            VStack {
                TweetCell(tweet: replyTo, tweetToNavigate: .constant(nil), userToNavigate: .constant(nil))
            }.padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }

    var headerView: some View {
        VStack(spacing: DisplayConstants.Sizes.padding) {
            HighlightTweetText(content: tweet.content)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(DateUtils.formatTimeAgo(from: tweet.date))
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
                TweetParentRepliesView().environmentObject(TweetRepliesViewModel(tweet: tweet))
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
        TweetDetailView(tweet: PreviewConstants.tweet).environmentObject(TweetDetailViewModel(tweet: PreviewConstants.replyTweet))
    }
}
