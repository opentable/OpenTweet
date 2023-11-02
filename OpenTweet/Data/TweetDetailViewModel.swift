//
//  TweetDetailViewModel.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

class TweetDetailViewModel: ObservableObject {
    enum State {
        case loading
        case loaded(tweets: [Tweet])
        case error
    }

    @Published private(set) var data: State = .loading

    var dataService: TweetDataService

    init(dataService: TweetDataService = TweetDataService.shared, tweet: Tweet) {
        self.dataService = dataService
        Task {
            do {
                let tweets = try await dataService.loadTweetReplies(tweetId: tweet.id)
                DispatchQueue.main.async {
                    self.data = State.loaded(tweets: tweets)
                }
            } catch {
                data = .error
            }
        }
    }
}
