//
//  TweetDataService.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

class TweetDataService {
    let bundle: Bundle

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

    func loadData(path: API.Path) async throws -> Data {
        if let url = getURL(path: path) {
            do {
                return try Data(contentsOf: url)
            } catch {
                throw API.APIError.fileNotFound
            }
        }
        throw API.APIError.fileNotFound
    }

    func getURL(path: API.Path) -> URL? {
        switch path {
        case .timeline:
            return bundle.url(forResource: "timeline", withExtension: "json")
        }
    }
}
