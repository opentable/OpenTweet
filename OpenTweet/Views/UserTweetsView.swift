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

    var body: some View {
        ScrollView {
            VStack {
                switch viewModel.data {
                case .loading:
                    ProgressView()
                case .loaded(let tweets):
                    ForEach(tweets, id: \.id) { tweet in
                        NavigationLink(value: tweet) {
                            TweetCell(
                                tweet: tweet
                            ).cellStyling
                        }.buttonStyle(.plain)
                    }
                case .error:
                    Text(LocalizableStrings.error.stringValue)
                }
            }.padding(DisplayConstants.Sizes.padding)
            Spacer()
        }.toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    ProfilePicture(user: viewModel.user, size: DisplayConstants.Sizes.imageSizeSmall)
                    Text(viewModel.user.author).font(.subheadline)
                }
            }}
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.user.author)
        .navigationDestination(item: $tweetToNavigate) { tweet in
            TweetDetailView().environmentObject(TweetDetailViewModel(tweet: tweet))
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
