import XCTest
@testable import OpenTweet

final class TweetsWorkerTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_fetchesTweetsFromLocalFile() {
        var localFileTweetsProvider = MockLocalFileTweetsProvider(tweets: [])
        var localTweetsProvider = LocalTweetsProvider(localFileTweetsProvider: localFileTweetsProvider)
        var tweetsWorker = TweetsWorker(localTweetsProvider: localTweetsProvider)
        XCTAssertTrue(try! tweetsWorker.fetchTweets().isEmpty)
        
        let tweets = [Tweet.testTweet()]
        localFileTweetsProvider = .init(tweets: tweets)
        localTweetsProvider = .init(localFileTweetsProvider: localFileTweetsProvider)
        tweetsWorker = .init(localTweetsProvider: localTweetsProvider)
        XCTAssertEqual(try! tweetsWorker.fetchTweets(), tweets)
    }
}
