//
//  TweetThreadViewModel.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import Foundation

class TweetRepliesViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded(replies: [Tweet])
        case error
        case maxDepth
    }

    @Published private(set) var data: State = .loading

    var dataService: TweetDataServiceable
    let tweet: Tweet
    let depth: Int
    private let maxDepth = 2

    init(dataService: TweetDataServiceable = TweetDataService.shared, tweet: Tweet, depth: Int = 0) {
        self.dataService = dataService
        self.tweet = tweet
        self.depth = depth
        guard depth < maxDepth else {
            data = .maxDepth
            return
        }
        Task {
            do {
                let tweets = try await dataService.loadTweetReplies(tweetId: tweet.id)
                DispatchQueue.main.async {
                    self.data = State.loaded(replies: tweets)
                }
            } catch {
                data = .error
            }
        }
    }
}
