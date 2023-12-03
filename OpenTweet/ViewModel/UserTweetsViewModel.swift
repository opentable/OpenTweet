//
//  UserTweetsViewModel.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

class UserTweetsViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded(tweets: [Tweet])
        case error
    }

    @Published private(set) var data: State = .loading
    var user: User
    var dataService: TweetDataServiceable

    init(dataService: TweetDataServiceable = TweetDataService.shared, user: User) {
        self.user = user
        self.dataService = dataService
        Task {
            do {
                let tweets = try await dataService.loadUserTweets(userName: user.author).sorted { $0.date > $1.date }
                DispatchQueue.main.async {
                    self.data = State.loaded(tweets: tweets)
                }
            } catch {
                data = .error
            }
        }
    }
}
