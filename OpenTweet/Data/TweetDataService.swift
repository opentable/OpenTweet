//
//  TweetDataService.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

class TweetDataService {
    private let file = (name: "timeline", extension: "json")

    enum APIError: Error, Equatable {
        case fileNotFound
        case decodingError(description: String)

        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.fileNotFound, .fileNotFound):
                return true
            case (.decodingError(_), .decodingError(_)):
                // ignore description
                return true
            default:
                return false
            }
        }
    }

    func loadTweets() async throws -> [TweetObject] {
        if let url = Bundle.main.url(forResource: file.name, withExtension: file.extension) {
            do {
                let data = try Data(contentsOf: url)

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let timeline = try decoder.decode(Timeline.self, from: data)
                print(timeline)
                return timeline.timeline
            } catch {
                throw APIError.decodingError(description: error.localizedDescription)
            }
        }
        throw APIError.fileNotFound
    }
}
