//
//  DataStructures.swift
//  OpenTweet
//
//  Created by Jesper Rage on 2024-02-04.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

enum TimelineOrder {
    case oldestToLatest
    case latestToOldest
}

struct Timeline: Decodable {
    var timeline: [Tweet]
    
    
    // returns Tweet pointed to by inReplyTo
    func originalPost(inReplyTo replyTweet: Tweet) -> Tweet? {
        if let replyId = replyTweet.inReplyTo {
            for tweet in timeline {
                if tweet.id == replyId {
                    return tweet
                }
            }
        }
        return nil
    }
    
    // Recursive reply search
    // Todo improve search algorithm, by relying on it being sorted, or only sort at the end
    func getReplies(to tweet: Tweet) -> [Tweet]? {
        var replies = [Tweet]()
        
        for possibleReply in timeline {
            if possibleReply.inReplyTo == tweet.id {

                replies += [possibleReply]
                
                if let recursiveReplies = getReplies(to: possibleReply) {
                    replies += recursiveReplies
                }
            }
        }

        // Sort based on date
        if replies.count > 0 {
            return sort(tweets: replies)
        } else {
            return nil
        }
    }
    
    // Sort based on date, newest to oldest
    func sort(tweets: [Tweet]?) -> [Tweet]? {
        if timelineOrder == .oldestToLatest {
            return tweets?.sorted { $0.date < $1.date }
        } else {
            return tweets?.sorted { $0.date > $1.date }
        }
    }
}

struct Tweet: Decodable {
    let id: String
    let author: String
    let avatar: String?
    let content: String
    let inReplyTo: String?
    let date: Date
}


