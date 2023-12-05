import XCTest
@testable import OpenTweet

final class LocalTweetsProviderTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_fetchesTweetsFromLocalFile() {
        var localFileTweetsProvider = MockLocalFileTweetsProvider(tweets: [])
        var localTweetsProvider = LocalTweetsProvider(localFileTweetsProvider: localFileTweetsProvider)
        XCTAssertTrue(try! localTweetsProvider.fetchLocalTweets().isEmpty)
        
        let tweets = [Tweet.testTweet()]
        localFileTweetsProvider = .init(tweets: tweets)
        localTweetsProvider = .init(localFileTweetsProvider: localFileTweetsProvider)
        XCTAssertEqual(try! localTweetsProvider.fetchLocalTweets(), tweets)
    }
}
