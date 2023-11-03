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
        
        XCTAssertEqual(viewModel.data, .loading)
        DispatchQueue.main.async {
            XCTAssertEqual(viewModel.data, .error)
        }
    }
}
