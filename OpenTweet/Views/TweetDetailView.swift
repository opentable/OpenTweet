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

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: DisplayConstants.Sizes.padding) {
                    HighlightTweetText(content: tweet.content)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(DisplayConstants.Sizes.padding)
                        .font(.headline)
                        .background(DisplayConstants.Colors.backgroundColor)
                        .cornerRadius(DisplayConstants.Sizes.cornerRadius)
                    Text(tweet.formattedDate()).font(.subheadline)
                }
                .padding(DisplayConstants.Sizes.padding)
                .background(DisplayConstants.Colors.backgroundColor)
                .cornerRadius(DisplayConstants.Sizes.cornerRadius)
                Spacer()
                switch viewModel.data {
                    case .loading:
                        ProgressView()
                    case .loaded(let tweets):
                        ForEach(tweets, id: \.id) {
                            TweetCell(tweet: $0, tweetToNavigate: .constant(nil))
                        }
                    case .error:
                        Text("Error")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitle(tweet.author, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    ProfilePicture(userName: tweet.author, avatar: tweet.avatar, size: DisplayConstants.Sizes.imageSizeSmall)
                    Text(tweet.author).font(.subheadline)
                }
            }
        }.padding(DisplayConstants.Sizes.padding)
    }
}

#Preview {
    NavigationStack {
        TweetDetailView(tweet: PreviewConstants.tweet).environmentObject(TweetDetailViewModel(tweet: PreviewConstants.tweet))
    }
}
