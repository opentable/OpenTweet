@testable import OpenTweet

struct MockLocalFileTweetsProvider: LocalFileTweetsProvidable {
    private let tweets: [Tweet]
    
    init(tweets: [Tweet]) {
        self.tweets = tweets
    }
    
    func fetchLocalFileTweets() throws -> [Tweet] {
        tweets
    }
}
