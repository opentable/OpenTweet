//
//  ContentView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject private var viewModel: TimelineViewModel
    @State var userToNavigate: User?

    var body: some View {
        ScrollView {
            VStack {
                switch viewModel.data {
                case .error:
                    Text(LocalizableStrings.error.stringValue)
                case .loading:
                    ProgressView()
                case .loaded(let tweets):
                    ForEach(tweets, id: \.id) { tweet in
                        NavigationLink(value: tweet) {
                            TweetCell(tweet: tweet)
                                .cellStyling

                        }.accessibilityIdentifier("TweetCell")
                            .buttonStyle(.plain)
                    }
                }
            }
            .padding(DisplayConstants.Sizes.largePadding)
            .navigationTitle(DisplayConstants.appTitle)
        }.navigationTitle(DisplayConstants.appTitle)
            .navigationDestination(item: $userToNavigate) { user in
                UserTweetsView().environmentObject(UserTweetsViewModel(user: user))
            }.onOpenURL(perform: { url in
                selectDeepLink(url)
            })
    }

    func selectDeepLink(_ url: URL) {
        guard userToNavigate == nil else {
            return
        }
        if let type = DeepLinkManager.handleIncomingURL(url) {
            switch type {
            case .user(let userName):
                Task {
                    let user = await viewModel.getUser(userName: userName)
                    userToNavigate = user
                }
            }
        }
    }
}

#Preview {
    return NavigationStack {
        TimelineView().environmentObject(TimelineViewModel())
    }
}
