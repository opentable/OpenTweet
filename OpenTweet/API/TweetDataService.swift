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

        return try await withCheckedThrowingContinuation { continuation in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            DispatchQueue.global(qos: .background).async {
                do {
                    let timeline = try decoder.decode(Timeline.self, from: data)
                    DispatchQueue.main.async {
                        continuation.resume(with: .success(timeline.timeline.compactMap { $0.toTweet() }))
                    }
                } catch {
                    continuation.resume(throwing: API.APIError.decodingError(description: error.localizedDescription))
                }
            }
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

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    private func loadData(path: API.Path) async throws -> Data {
        if let url = getURL(path: path) {
            return try await withCheckedThrowingContinuation { continuation in
                getData(from: url) { data, _, _ in
                    if let data = data {
                        continuation.resume(returning: data)
                        return
                    }
                    continuation.resume(throwing: API.APIError.fileNotFound)
                }
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
