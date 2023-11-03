//
//  TweetDetailView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct TweetDetailView: View {
    @EnvironmentObject private var viewModel: TweetDetailViewModel
    @State var tweetToNavigate: Tweet?
    @State var userToNavigate: User?
    
    func replyToView(replyTo: Tweet) -> some View {
        VStack(alignment: .leading) {
            Text(LocalizableStrings.inReplyTo.stringValue).font(.headline)
            VStack {
                TweetCell(
                    tweet: replyTo,
                    tweetToNavigate: $tweetToNavigate,
                    userToNavigate: $userToNavigate
                )
            }.padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
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
                TweetParentRepliesView(
                    tweetToNavigate: $tweetToNavigate,
                    userToNavigate: $userToNavigate
                ).environmentObject(TweetRepliesViewModel(tweet: viewModel.tweet))
            }
            .padding(DisplayConstants.Sizes.largePadding)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    ProfilePicture(user: viewModel.tweet.toUser(), size: DisplayConstants.Sizes.imageSizeSmall)
                    Text(viewModel.tweet.author).font(.subheadline)
                }
            }}
        .navigationTitle(viewModel.tweet.content)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $tweetToNavigate) { tweet in
            TweetDetailView().environmentObject(TweetDetailViewModel(tweet: tweet))
        }.navigationDestination(item: $userToNavigate) { user in
            UserTweetsView().environmentObject(UserTweetsViewModel(user: user))
        }
    }
}

#Preview {
    NavigationStack {
        TweetDetailView(
        ).environmentObject(TweetDetailViewModel(tweet: PreviewConstants.replyTweet))
    }
}
