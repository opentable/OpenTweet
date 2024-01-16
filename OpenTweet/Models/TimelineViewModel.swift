//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by Dante Li on 2024-01-14.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Combine
import Foundation

protocol TimelineViewModel {
    var tweetsPublisher: AnyPublisher<[Tweet], Never> { get }
    func fetchData()
    func retrieveAvatar(in tweet: Tweet) async -> Data?
}

final class TimelineViewModelImpl: TimelineViewModel {
    
    lazy var tweetsPublisher: AnyPublisher<[Tweet], Never> = $tweets.eraseToAnyPublisher()
    @Published private var tweets: [Tweet] = []
    
    private var tweetsMap: [String: Tweet] = [:]    // [Tweet.id: Tweet]
    private var tweetRepliesMap: [String: [String]] = [:]   // [Tweet.id: [Tweet.id]]

    private lazy var networks = Networks()
    
    func fetchData() {
        guard let filePath = Bundle.main.url(forResource: "timeline", withExtension: "json") else {
            fatalError("Couldn't find the directory that has the data file!")
        }
        
        do {
            let data = try Data(contentsOf: filePath)
            let decoded = try JSONDecoder().decode(Timeline.self, from: data)
            tweets = decoded.timeline.sorted(by: {  $0.dateString.iso8601Date ?? Date() < $1.dateString.iso8601Date ?? Date() })
            
            //print("Decoded the data: \(tweets)")
            
            tweetsMap = Dictionary(uniqueKeysWithValues: tweets.map { ($0.id, $0) })
            
            tweets.forEach { tweet in
                if let replyTo = tweet.replyTo {
                    // Fetches the tweet that the input tweet replies to
                    tweet.tweetReplyTo = tweetsMap[replyTo]
                    
                    // Maps the reply IDs to each tweet
                    tweetRepliesMap[replyTo, default: []].append(tweet.id)
                }
            }
            
            tweets.forEach { tweet in
                tweet.replies = fetchTweetReplies(on: tweet.id)
            }
            
        } catch {
            print("Error decoding the data: \(error)")
        }
    }
    
    func retrieveAvatar(in tweet: Tweet) async -> Data? {
        guard let avatarLink = tweet.avatarLink else { return nil }
        
        if let url = URL(string: avatarLink) {
            let data = await networks.download(url: url)
            
            tweet.avatarData = data
            return data
        }
        
        return nil
    }
        
    // Returns the replies to the input tweet
    private func fetchTweetReplies(on tweetID: String) -> [Tweet] {
        guard let directReplyIDs = tweetRepliesMap[tweetID] else { return [] }
        
        let replies = directReplyIDs.compactMap { tweetsMap[$0] }
        return replies.sorted(by: {  $0.dateString.iso8601Date ?? Date() < $1.dateString.iso8601Date ?? Date() })
    }
}
