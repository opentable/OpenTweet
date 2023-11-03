//
//  TweetDataService.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

protocol TweetDataServiceable {
    func loadTweets() async throws -> [Tweet]
    func loadUserTweets(userName: String) async throws -> [Tweet]
    func loadTweetReplies(tweetId: String) async throws -> [Tweet]
    func loadTweet(tweetId: String) async throws -> Tweet?
    func loadUser(userName: String) async throws -> User?
}

class TweetDataService: TweetDataServiceable {
    let bundle: Bundle
    static let shared: TweetDataService = TweetDataService()

    init(bundle: Bundle = Bundle.main) {
        self.bundle = bundle
    }

    func loadTweets() async throws -> [Tweet] {
        let data = try await loadData(path: .timeline)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let timeline = try decoder.decode(Timeline.self, from: data)

            print(timeline)

            // convert to local object before returning
            return timeline.timeline.compactMap { $0.toTweet() }
        } catch {
            throw API.APIError.decodingError(description: error.localizedDescription)
        }
    }

    func loadUserTweets(userName: String) async throws -> [Tweet] {
        return try await loadTweets().filter { $0.author == userName }
    }

    func loadTweetReplies(tweetId: String) async throws -> [Tweet] {
        return try await loadTweets().filter { $0.inReplyTo == tweetId }
    }

    func loadTweet(tweetId: String) async throws -> Tweet? {
        return try await loadTweets().first { $0.id == tweetId }
    }

    func loadUser(userName: String) async throws -> User? {
        return try await loadTweets().first { $0.author == userName }?.toUser()
    }

    private func loadData(path: API.Path) async throws -> Data {
        if let url = getURL(path: path) {
            do {
                return try Data(contentsOf: url)
            } catch {
                throw API.APIError.fileNotFound
            }
        }
        throw API.APIError.fileNotFound
    }

    private func getURL(path: API.Path) -> URL? {
        switch path {
        case .timeline, .user:
            return bundle.url(forResource: "timeline", withExtension: "json")
        }
    }
}
