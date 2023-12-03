//
//  TweetRepliesViewModelTests.swift
//  OpenTweetTests
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import XCTest

class TweetRepliesViewModelTests: XCTestCase {

    func testLoadingState() {
        let replyTweet = PreviewConstants.replyTweet
        let viewModel = TweetRepliesViewModel(dataService: MockTweetDataService(shouldSucceed: true, tweetToReturn: replyTweet), tweet: replyTweet)
        XCTAssertEqual(viewModel.data, .loading)
    }
    
    func testLoadedState() {
        let tweet = PreviewConstants.tweet
        let replies = [PreviewConstants.replyTweet]
        let dataService = MockTweetDataService(shouldSucceed: true, tweetToReturn: tweet)
        let viewModel = TweetRepliesViewModel(dataService: dataService, tweet: tweet)
        
        XCTAssertEqual(viewModel.data, .loading)
        
        // Simulate the asynchronous data loading
        DispatchQueue.main.async {
            XCTAssertEqual(viewModel.data, .loaded(replies: replies))
        }
    }
    
    func testErrorState() {
        let tweet = PreviewConstants.tweet
        
        let dataService = MockTweetDataService(shouldSucceed: false, tweetToReturn: nil)
        
        let viewModel = TweetReplyToViewModel(dataService: dataService, tweet: tweet)
        
        DispatchQueue.main.async {
            if case .error(let description) = viewModel.data {
                XCTAssertEqual(description, "TestErrorDomain")
            } else {
                XCTFail("Expected error state with description")
            }
        }
    }
}
