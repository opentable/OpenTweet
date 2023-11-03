//
//  UserTweetsViewModel.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

class UserTweetsViewModel: ObservableObject {
    enum State {
        case loading
        case loaded(tweets: [Tweet])
        case error
    }

    @Published private(set) var data: State = .loading
    var user: User
    var dataService: TweetDataService

    init(dataService: TweetDataService = TweetDataService.shared, user: User) {
        self.user = user
        self.dataService = dataService
        Task {
            do {
                let tweets = try await dataService.loadUserTweets(userName: user.author)
                DispatchQueue.main.async {
                    self.data = State.loaded(tweets: tweets)
                }
            } catch {
                data = .error
            }
        }
    }
}
