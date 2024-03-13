//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-11.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import Combine

public typealias Completion = (() -> Void)
public typealias Callback<T> = ((T) -> Void)

protocol TimelineViewModelInterface {
    func loadTimelineFeed()
    func tappedOn(tweet: Tweet)
    var statePublisher: Published<TimelineViewModel.State>.Publisher { get }
}

final class TimelineViewModel: TimelineViewModelInterface {
    enum State: Equatable {
        case loading
        case loaded(timeline: [Tweet])
        case error(TimelineServiceError)
    }

    @Published private(set) var feedState: State = .loading
    var statePublisher: Published<State>.Publisher { $feedState }

    let timelineService: TimelineServiceProtocol
    let onTweetTapped: Callback<Tweet>?

    init(timelineService: TimelineServiceProtocol, onTweetTapped: Callback<Tweet>?) {
        self.timelineService = timelineService
        self.onTweetTapped = onTweetTapped
    }
    
    func loadTimelineFeed() {
        Task(priority: .high) { [weak self] in
            guard let self = self else { return }
            do {
                var result = try timelineService.loadTimelineFeed()
                result.timeline.sort { $0.date < $1.date }
                self.configureTweetFeed(tweets: result.timeline)

                await MainActor.run { [result] in
                    self.feedState = .loaded(timeline: result.timeline)
                }
            } catch {
                
            }
        }
    }
    
    private func configureTweetFeed(tweets: [Tweet]) {
        defer {
            for tweet in tweets {
                tweet.tweetReplies?.sort { $0.date < $1.date }
            }
        }

        let tweetsMapping = Dictionary(uniqueKeysWithValues: tweets.map { ($0.id, $0) })

        for tweet in tweets {
            if let tweetInReplyToId = tweet.inReplyTo,
               let tweetInReplyTo = tweetsMapping[tweetInReplyToId]
            {
                tweetInReplyTo.tweetReplies = (tweetInReplyTo.tweetReplies ?? []) + [tweet]
                tweet.tweetRepliesTo = tweetInReplyTo
            }
        }
    }
    
    func tappedOn(tweet: Tweet) {
        onTweetTapped?(tweet)
    }
}
