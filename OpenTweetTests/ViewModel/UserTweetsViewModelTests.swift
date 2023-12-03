//
//  UserTweetsViewModelTests.swift
//  OpenTweetTests
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import XCTest

class UserTweetsViewModelTests: XCTestCase {

    func testLoadingState() {
        let user = PreviewConstants.tweet.toUser()
        let viewModel = UserTweetsViewModel(dataService: MockTweetDataService(shouldSucceed: true, tweetToReturn: nil), user: user)
        XCTAssertEqual(viewModel.data, .loading)
    }
    
    func testLoadedState() {
        let user = PreviewConstants.tweet.toUser()
        let tweet = PreviewConstants.tweet
        let dataService = MockTweetDataService(shouldSucceed: true, tweetToReturn: tweet)
        let viewModel = UserTweetsViewModel(dataService: dataService, user: user)
        
        XCTAssertEqual(viewModel.data, .loading)
        
        // Simulate the asynchronous data loading
        DispatchQueue.main.async {
            XCTAssertEqual(viewModel.data, .loaded(tweets: [tweet]))
        }
    }
    
    func testErrorState() {
        let user = PreviewConstants.tweet.toUser()
        let dataService = MockTweetDataService(shouldSucceed: false, tweetToReturn: nil)
        let viewModel = UserTweetsViewModel(dataService: dataService, user: user)
        
        DispatchQueue.main.async {
            XCTAssertEqual(viewModel.data, .error)
        }
    }
}
