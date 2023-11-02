//
//  LocalDataService.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

class API {
    enum Path {
        case timeline
    }

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
}
