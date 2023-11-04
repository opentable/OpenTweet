//
//  UserTweetsView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

struct UserTweetsView: View {
    @EnvironmentObject private var viewModel: UserTweetsViewModel
    @State var tweetToNavigate: Tweet?
    @State var userToNavigate: User?

    func getHeaderView(_ tweets: [Tweet]) -> some View {
        return HStack(spacing: DisplayConstants.Sizes.largePadding) {
            ProfilePicture(user: viewModel.user, size: DisplayConstants.Sizes.imageSizeLarge)
            VStack {
                Text(LocalizableStrings.posts.stringValue).font(.headline)
                Text("\(tweets.count)").font(.subheadline)
            }
            VStack {
                Text(LocalizableStrings.following.stringValue).font(.headline)
                Text("321").font(.subheadline)
            }
            VStack {
                Text(LocalizableStrings.followers.stringValue).font(.headline)
                Text("100").font(.subheadline)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                switch viewModel.data {
                case .loading:
                    getHeaderView([])
                    ProgressView()
                case .loaded(let tweets):
                    getHeaderView(tweets)
                    Text(LocalizableStrings.posts.stringValue).font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(tweets, id: \.id) { tweet in
                        TweetRepliesView(small: true)
                            .cellStyling
                            .environmentObject(TweetRepliesViewModel(tweet: tweet))
                    }
                case .error:
                    getHeaderView([])
                    Text(LocalizableStrings.error.stringValue)
                }
            }.padding(DisplayConstants.Sizes.largePadding)
            Spacer()
        }.toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(viewModel.user.author).font(.subheadline)
                }
            }}
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.user.author)
        .navigationDestination(item: $tweetToNavigate) { tweet in
            TweetDetailView(tweet: tweet)
        }.navigationDestination(item: $userToNavigate) { user in
            UserTweetsView().environmentObject(UserTweetsViewModel(user: user))
        }
    }
}

#Preview {
    NavigationStack {
        UserTweetsView()
            .environmentObject(UserTweetsViewModel(user: PreviewConstants.replyTweet.toUser()))
    }
}
