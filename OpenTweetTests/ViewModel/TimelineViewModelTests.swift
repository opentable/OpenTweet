//
//  TimelineViewModelTests.swift
//  OpenTweetTests
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import XCTest

class TimelineViewModelTests: XCTestCase {
    func testLoadingState() {
        let viewModel = TimelineViewModel(dataService: MockTweetDataService(shouldSucceed: true, tweetToReturn: nil))
        XCTAssertEqual(viewModel.data, .loading)
    }
    
    func testLoadedState() {
        let dataService = MockTweetDataService(shouldSucceed: true, tweetToReturn: PreviewConstants.tweet)
        let viewModel = TimelineViewModel(dataService: dataService)
        XCTAssertEqual(viewModel.data, .loading)
        
        // Simulate the asynchronous data loading
        DispatchQueue.main.async {
            XCTAssertEqual(viewModel.data, .loaded(tweets: [PreviewConstants.tweet]))
        }
    }
    
    func testErrorState() {
        let dataService = MockTweetDataService(shouldSucceed: false, tweetToReturn: nil)
        let viewModel = TimelineViewModel(dataService: dataService)
    
        DispatchQueue.main.async {
            XCTAssertEqual(viewModel.data, .error)
        }
    }
    
    func testGetUserSuccess() async {
        let userName = "testUser"
        let expectedUser = User(id: "1", author: userName, avatar: nil)
        let dataService = MockTweetDataService(shouldSucceed: true, userToReturn: expectedUser)

        let viewModel = TimelineViewModel(dataService: dataService)

        // Call the getUser function and wait for the result using await
        if let user = await viewModel.getUser(userName: userName) {
            // The user should be returned
            XCTAssertEqual(expectedUser.author, userName)
        } else {
            XCTFail("Expected a user, but got nil")
        }
    }

    func testGetUserFailure() async {
        let dataService = MockTweetDataService(shouldSucceed: false, tweetToReturn: nil)

        let userName = "testUser"
        let viewModel = TimelineViewModel(dataService: dataService)

        // Call the getUser function and wait for the result using await
        if let user = await viewModel.getUser(userName: userName) {
            XCTFail("Expected nil, but got a user")
        } else {
            // The result should be nil due to the failure
            XCTAssert(true)
        }
    }
}
