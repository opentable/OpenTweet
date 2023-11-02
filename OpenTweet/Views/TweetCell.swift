//
//  TweetCell.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct TweetCell: View {
    let tweet: Tweet

    var body: some View {
        VStack(alignment: .leading, spacing: DisplayConstants.padding) {
            Text(tweet.author).font(.subheadline)
            Text(tweet.formattedDate()).font(.subheadline)
            Text(tweet.content)
                .font(.headline)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(DisplayConstants.padding)
        .background(DisplayConstants.backgroundColor)
        .cornerRadius(DisplayConstants.cornerRadius)
        .onTapGesture {
            print("Selected \(tweet.content)")
        }
    }
}

#Preview {
    TweetCell(tweet: PreviewConstants.tweet)
}
