//
//  TweetReplyToView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

struct TweetReplyToView: View {
    @EnvironmentObject private var viewModel: TweetReplyToViewModel

    var body: some View {
        switch viewModel.data {
        case .error:
            Text(LocalizableStrings.error.stringValue)
        case .loaded(let replyTo):
            if let replyTo = replyTo {
                NavigationLink(value: replyTo) {
                    VStack(alignment: .leading) {
                        Text(LocalizableStrings.inReplyTo.stringValue).font(.headline)
                        VStack {
                            TweetCell(
                                tweet: replyTo
                            )}.padding(DisplayConstants.Sizes.padding)
                            .background(DisplayConstants.Colors.backgroundColor)
                            .cornerRadius(DisplayConstants.Sizes.cornerRadius)
                    }
                }.buttonStyle(.plain)
            }
        case .loading:
            EmptyView()
        }
    }
}
