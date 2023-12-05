import Foundation

/// Provides the tweets from a local database or a local file
protocol LocalTweetsProvidable {
    func fetchLocalTweets() throws -> [Tweet]
}

struct LocalTweetsProvider {
    let localFileTweetsProvider: LocalFileTweetsProvidable
}

extension LocalTweetsProvider: LocalTweetsProvidable {
    func fetchLocalTweets() throws -> [Tweet] {
        try localFileTweetsProvider.fetchLocalFileTweets()
    }
}
