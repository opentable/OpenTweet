//
//  UserTweetsView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

struct UserTweetsView: View {
    @EnvironmentObject private var viewModel: UserTweetsViewModel
    let user: User

    var body: some View {
        ScrollView {
            VStack {
                switch viewModel.data {
                case .loading:
                    ProgressView()
                case .loaded(let tweets):
                    ForEach(tweets, id: \.id) { tweet in
                        TweetCell(
                            tweet: tweet,
                            tweetToNavigate: .constant(nil),
                            userToNavigate: .constant(nil)
                        ).cellStyling
                    }
                case .error:
                    Text(LocalizableStrings.error.stringValue)
                }
            }.padding(DisplayConstants.Sizes.padding)
            Spacer()
        }.toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    ProfilePicture(user: user, size: DisplayConstants.Sizes.imageSizeSmall)
                    Text(user.author).font(.subheadline)
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UserTweetsView(user: PreviewConstants.tweet.toUser())
}
