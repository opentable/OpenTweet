import Foundation

/// Tweets API
protocol TweetsWorkable {
    func fetchTweets() throws -> [Tweet]
    func fetchTweets(repliedTo tweetId: String) throws -> [Tweet]
}

struct TweetsWorker {
    let localTweetsProvider: LocalTweetsProvidable
}

extension TweetsWorker: TweetsWorkable {
    func fetchTweets() throws -> [Tweet] {
        try localTweetsProvider.fetchLocalTweets()
    }
    
    func fetchTweets(repliedTo tweetId: String) throws -> [Tweet] {
        try fetchTweets().filter { $0.inReplyTo == tweetId }
    }
}
