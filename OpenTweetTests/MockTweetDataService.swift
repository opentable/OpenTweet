//
//  MockTweetDataService.swift
//  OpenTweetTests
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import XCTest

class MockTweetDataService: TweetDataServiceable {
    var shouldSucceed = true
    var tweetsToReturn: [Tweet] {
        guard let tweet = tweetToReturn else {
            return []
        }
        return [tweet]
    }
    var tweetToReturn: Tweet?
    
    init(shouldSucceed: Bool, tweetToReturn: Tweet?) {
        self.shouldSucceed = shouldSucceed
        self.tweetToReturn = tweetToReturn
    }
    
    private func loadTweets(_ continuation: CheckedContinuation<[Tweet], Error>) {
        if self.shouldSucceed {
            continuation.resume(returning: self.tweetsToReturn)
        } else {
            continuation.resume(throwing: NSError(domain: "TestErrorDomain", code: 0, userInfo: nil))
        }
    }
    
    private func loadTweet(_ continuation: CheckedContinuation<Tweet?, Error>) {
        if self.shouldSucceed {
            continuation.resume(returning: self.tweetToReturn)
        } else {
            continuation.resume(throwing: NSError(domain: "TestErrorDomain", code: 0, userInfo: nil))
        }
    }

    func loadTweets() async throws -> [Tweet] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                self.loadTweets(continuation)
            }
        }
    }

    func loadUserTweets(userName: String) async throws -> [Tweet] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                self.loadTweets(continuation)
            }
        }
    }

    func loadTweetReplies(tweetId: String) async throws -> [Tweet] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                self.loadTweets(continuation)
            }
        }
    }

    func loadTweet(tweetId: String) async throws -> Tweet? {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                self.loadTweet(continuation)
            }
        }
    }
}
