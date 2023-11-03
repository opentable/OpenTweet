//
//  TweetDetailViewModel.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

class TweetDetailViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded(replyTo: Tweet?)
        case error(description: String)
    }

    @Published private(set) var data: State = .loading

    var dataService: TweetDataServiceable
    let tweet: Tweet

    init(dataService: TweetDataServiceable = TweetDataService.shared, tweet: Tweet) {
        self.dataService = dataService
        self.tweet = tweet
        guard let inReplyTo = tweet.inReplyTo else {
            data = .loaded(replyTo: nil)
            return
        }
        guard inReplyTo != tweet.id else {
            data = .error(description: "A tweet can't reply to itself")
            return
        }
        Task {
            do {
                let tweet = try await dataService.loadTweet(tweetId: inReplyTo)
                DispatchQueue.main.async {
                    self.data = State.loaded(replyTo: tweet)
                }
            } catch {
                data = .error(description: error.localizedDescription)
            }
        }
    }
}
