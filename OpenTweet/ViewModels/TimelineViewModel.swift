//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-27.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Combine
import Foundation

protocol TimelineViewConfiguring {
    var publisher: AnyPublisher<[Tweet], Never> { get }
    
    func fetchTweets()
}

final class TimelineViewModel: TimelineViewConfiguring {
    lazy var publisher: AnyPublisher<[Tweet], Never> = $tweets.eraseToAnyPublisher()
    
    @Published private var tweets: [Tweet] = []
    
    private var tweetsMap: [String: Tweet] = [:] // mapping of Tweet.id -> Tweet
    private var tweetRepliesMap: [String: [String]] = [:] // mapping of Tweet.id -> list of Tweet.id
    
    func fetchTweets() {
        let timelineObject = FileLoader.parseLocalJSONFile(fileName: "timeline", decodingType: Timeline.self)
        
        guard let timeline = timelineObject else {
            return
        }
        tweets = timeline.timeline.sorted(by: { (firstTweet, secondTweet) in
            // sort in reverse chronological order
            firstTweet.getDateFromTweet() < secondTweet.getDateFromTweet()
        })
        
        tweetsMap = Dictionary(uniqueKeysWithValues: tweets.map { tweet in
            (tweet.id, tweet) // mapping of Tweet.id -> Tweet
        })
        
        for tweet in tweets {
            if let inReplyToTweetId = tweet.inReplyTo {
                // fetch replying tweet and map the replying tweetId to each tweet
                tweet.replyToTweet = tweetsMap[inReplyToTweetId]
                tweetRepliesMap[inReplyToTweetId, default: []].append(tweet.id)
            }
        }
        
        for tweet in tweets {
            tweet.tweetReplies = fetchTweetReplies(for: tweet.id)
        }
    }
}

private extension TimelineViewModel {
    func fetchTweetReplies(for tweetId: String) -> [Tweet] {
        guard let replyingTweetIds = tweetRepliesMap[tweetId] else {
            return []
        }
        
        let tweetReplies = replyingTweetIds.compactMap { tweetId in
            tweetsMap[tweetId]
        }
        
        return tweetReplies.sorted(by: { (firstTweet, secondTweet) in
            // sort in reverse chronological order
            firstTweet.getDateFromTweet() > secondTweet.getDateFromTweet()
        })
    }
}
