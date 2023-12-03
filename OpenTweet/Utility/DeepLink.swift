//
//  DeepLink.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import Foundation

class DeepLinkManager {
    enum LinkType {
        case user(username: String)

        var linkValue: String {
            switch self {
            case .user(let userName):
                "openTweet://open-user?user=\(userName)"
            }
        }
    }

    static func handleUser(_ components: URLComponents) -> LinkType? {
        guard let action = components.host, action == "open-user" else {
            print("Unknown URL, we can't handle this one!")
            return nil
        }

        guard let userName = components.queryItems?.first(where: { $0.name == "user" })?.value else {
            print("User not found")
            return nil
        }
        print("selected deep link \(userName)")
        return .user(username: userName)
    }

    static func handleIncomingURL(_ url: URL) -> LinkType? {
        guard url.scheme == "openTweet" else {
            return nil
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return nil
        }

        return handleUser(components)
    }
}
