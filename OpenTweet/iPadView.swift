//
//  BaseView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

struct BaseView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass == .compact {
            NavigationStack {
                TimelineView().environmentObject(
                    TimelineViewModel()
                ).navigationDestination(for: Tweet.self) { tweet in
                    TweetDetailView(tweet: tweet)
                }.navigationDestination(for: User.self) { user in
                    UserTweetsView().environmentObject(UserTweetsViewModel(user: user))
                }
            }
        } else {
            // On iPad or when in split view
            iPadView()
        }
    }
}

struct iPadView: View {
    @State var selectedTweet: Tweet?

    var body: some View {
        NavigationSplitView(
            columnVisibility: .constant(.doubleColumn)
        ) {
            TimelineView().environmentObject(
                TimelineViewModel()
            ).navigationDestination(for: Tweet.self) { tweet in
                TweetDetailView(tweet: tweet)
            }.navigationDestination(for: User.self) { user in
                UserTweetsView().environmentObject(UserTweetsViewModel(user: user))
            }
        } detail: {
            EmptyView()
        }.navigationSplitViewStyle(.balanced)
    }
}
