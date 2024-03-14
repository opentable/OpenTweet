//
//  TweetCellView.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct TweetCellView: View {
  var tweet: Tweet
  
  init(tweet: Tweet) {
    self.tweet = tweet
  }
  
  var body: some View {
    HStack(alignment: .top) {
      Image(systemName: "person.fill")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .background(Color.blue)
        .overlay(
          Circle()
            .stroke(.white, lineWidth: 2)
        )
        .clipShape(Circle())
        .frame(width: 40, height: 40)
      
      VStack(alignment: .leading) {
        Text(tweet.author)
          .font(.headline)
        Text(tweet.date.timelineTimestamp())
          .font(.footnote)
        Text(tweet.content)
          .font(.body)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.all, 20)
    .background(container)
    .frame(maxWidth: .infinity)
  }
  
  var container: some View {
    Rectangle()
      .fill(Color.secondary)
      .cornerRadius(12)
      .shadow(
        color: Color.gray.opacity(0.7),
        radius: 8,
        x: 0,
        y: 0
      )
  }
}

#if DEBUG
struct TweetCellView_Previews: PreviewProvider {
  static var previews: some View {
    TweetCellView(tweet: MockTimelineService.mockTweet(messageNumber: 123, isShortMessage: true))
      .padding(10)
  }
}
#endif
