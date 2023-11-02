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
                            TweetCell(tweet: tweet, tweetToNavigate: $tweetToNavigate)
                        }
                    }
                }
                .padding(DisplayConstants.Sizes.largePadding)
                .navigationTitle(DisplayConstants.appTitle)
            }.navigationDestination(item: $tweetToNavigate) { tweet in
                TweetDetailView(
                    tweet: tweet
                ).environmentObject(TweetDetailViewModel(tweet: tweet))
            }
        }
    }
}

#Preview {
    return TimelineView().environmentObject(TimelineViewModel())
}
