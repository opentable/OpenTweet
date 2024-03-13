//
//  TimelineService.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-12.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

protocol TimelineServiceProtocol {
    func loadTimelineFeed() throws -> Timeline
}

public enum TimelineServiceError: Error {
    case filePathError
    case dataConversionError
    case decodingError
}

final class TimelineService: TimelineServiceProtocol {
    func loadTimelineFeed() throws -> Timeline {
        let filename = "timeline"
        let fileType = "json"

        guard let path = Bundle.main.url(forResource: filename, withExtension: fileType, subdirectory: nil) else {
            throw TimelineServiceError.filePathError
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Timeline.self, from: data)
                return result
            } catch {
                throw TimelineServiceError.decodingError
            }
        } catch {
            throw TimelineServiceError.dataConversionError
        }
    }
}
