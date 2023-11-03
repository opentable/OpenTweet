//
//  ContentView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject private var viewModel: TimelineViewModel
    @State var tweetToNavigate: Tweet?
    @State var userToNavigate: User?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    switch viewModel.data {
                    case .error:
                        Text("Error")
                    case .loading:
                        ProgressView()
                    case .loaded(let tweets):
                        ForEach(tweets, id: \.id) { tweet in
                            TweetCell(tweet: tweet, tweetToNavigate: $tweetToNavigate, userToNavigate: $userToNavigate).cellStyling
                        }
                    }
                }
                .padding(DisplayConstants.Sizes.largePadding)
                .navigationTitle(DisplayConstants.appTitle)
            }.navigationDestination(item: $tweetToNavigate) { tweet in
                TweetDetailView(
                    tweet: tweet
                ).environmentObject(TweetDetailViewModel(tweet: tweet))
            }.navigationDestination(item: $userToNavigate) { user in
                UserTweetsView(user: user)
                    .environmentObject(UserTweetsViewModel(user: user))
            }
        }
    }
}

#Preview {
    return TimelineView().environmentObject(TimelineViewModel())
}
