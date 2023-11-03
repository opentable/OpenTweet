//
//  TweetDataRepository.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

class TimelineViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded(tweets: [Tweet])
        case error
    }

    @Published private(set) var data: State = .loading

    var dataService: TweetDataServiceable

    init(dataService: TweetDataServiceable = TweetDataService.shared) {
        self.dataService = dataService
        Task {
            do {
                let tweets = try await dataService.loadTweets()
                DispatchQueue.main.async {
                    self.data = State.loaded(tweets: tweets)
                }
            } catch {
                data = .error
            }
        }
    }
}
