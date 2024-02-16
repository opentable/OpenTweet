//
//  FileManager+Extension.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

extension FileManager {
    func loadData() -> [Tweet] {
        guard let path = Bundle.main.path(forResource:"timeline", ofType: "json"),
              let data = contents(atPath: path) else { return [] }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let timeline = try? decoder.decode(Timeline.self, from: data) else {
            return []
        }

        return timeline.timeline
    }

    func getNewsTweet() -> [Tweet] {
        return [generateRandomTweet()];
    }

    func generateRandomTweet() -> Tweet {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let oldest = formatter.date(from: "2020/09/30")!.timeIntervalSince1970
        let newest = formatter.date(from: "2020/10/02")!.timeIntervalSince1970
        let range = newest - oldest

        let tweets = [Tweet(id: "",
                            author: "@alice",
                            content: "I'm in wonderland",
                            avatar: "https://clipart-library.com/img/1102183.png",
                            date: Date(timeIntervalSince1970: oldest + Double.random(in: 0..<range)),
                            inReplyTo: nil),
                      Tweet(id: "",
                            author: "@OpenTable",
                            content: "Book now!. Great savings",
                            avatar: "https://media.trustradius.com/vendor-logos/uS/vv/LZ7XO1E8F9TP-180x180.JPEG",
                            date: Date(timeIntervalSince1970: oldest + Double.random(in: 0..<range)),
                            inReplyTo: nil),
                      Tweet(id: "",
                            author: "@ChefRamsey",
                            content: "I love OpenTable",
                            avatar: "https://cdn.foodbeast.com/content/uploads/2015/04/Gordon-Ramsay-Feat.jpg",
                            date: Date(timeIntervalSince1970: oldest + Double.random(in: 0..<range)),
                            inReplyTo: nil),
                      Tweet(id: "",
                            author: "@MoxiesKitchener",
                            content: "We have some bookings available. Please use OpenTable.",
                            avatar: "https://pbs.twimg.com/profile_images/1437525220991004678/OhUK4LR1_400x400.jpg",
                            date: Date(timeIntervalSince1970: oldest + Double.random(in: 0..<range)),
                            inReplyTo: nil),
        ]
        return tweets.randomElement()!
    }
}
