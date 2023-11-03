//
//  TweetReplyView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import SwiftUI

struct TweetReplyView: View {
    let replies: [Tweet]
    
    var body: some View {
        Text("Replies").font(.headline)
        ForEach(replies, id: \.id) {
            TweetCell(tweet: $0, tweetToNavigate: .constant(nil), userToNavigate: .constant(nil))
        }
    }
}
