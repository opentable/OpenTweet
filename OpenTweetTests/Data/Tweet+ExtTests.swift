import XCTest
@testable import OpenTweet

final class Tweet_ExtTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_tweetContent_mentionMatches() {
        let content = "@test tells us if there are mentions like @test"
        let tweet = Tweet.testTweet(content: content)
        
        XCTAssertEqual(tweet.contentMentionMatches?.count, 2)
        XCTAssertEqual(tweet.contentMentionMatches?[0].range, .init(location: 0, length: 5))
        XCTAssertEqual(tweet.contentMentionMatches?[1].range, .init(location: 42, length: 5))
    }
    
    func test_tweetContent_hashtagMatches() {
        let content = "#test is really important"
        let tweet = Tweet.testTweet(content: content)
        
        XCTAssertEqual(tweet.contentHashtagMatches?.count, 1)
        XCTAssertEqual(tweet.contentHashtagMatches?[0].range, .init(location: 0, length: 5))
    }
    
    func test_tweetContent_urlMatches() {
        let content = "Test link https://www.opentable.ca"
        let tweet = Tweet.testTweet(content: content)
        
        XCTAssertEqual(tweet.contentUrlMatches?.count, 1)
        XCTAssertEqual(tweet.contentUrlMatches?[0].range, .init(location: 10, length: 24))
    }
}
