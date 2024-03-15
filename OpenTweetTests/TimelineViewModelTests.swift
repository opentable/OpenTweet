//
//  TimelineViewModelTests.swift
//  OpenTweetTests
//
//  Created by HU QI on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import XCTest
//@testable import OpenTweet
import Combine

class TimelineViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFeedLoading() {
        let viewModel = TimelineViewModel(timelineService: TimelineService(), onTweetTapped: nil)
        XCTAssertEqual(viewModel.feedState, TimelineViewModel.State.loading)
    }
    
    func testTimelineServiceError() {
        let timelineService = MockErrorTimelineService()
        let viewModel = TimelineViewModel(timelineService: timelineService, onTweetTapped: nil)
        XCTAssertEqual(viewModel.feedState, TimelineViewModel.State.loading)
        DispatchQueue.main.async {
            XCTAssertEqual(viewModel.feedState, TimelineViewModel.State.error(TimelineServiceError.decodingError))
        }
    }
    
    func testFeedLoaded() {
        let timelineService = ConfigurableTimelineService(filename: "timelineTestOne", fileType: "json")
        let viewModel = TimelineViewModel(timelineService: timelineService, onTweetTapped: nil)
        XCTAssertEqual(viewModel.feedState, TimelineViewModel.State.loading)
        DispatchQueue.main.async {
            XCTAssertEqual(viewModel.feedState, TimelineViewModel.State.loaded(timeline: []))
        }
    }
}

class MockErrorTimelineService: TimelineServiceProtocol {
    func loadTimelineFeed() throws -> Timeline {
        throw TimelineServiceError.decodingError
    }
}

class ConfigurableTimelineService: TimelineServiceProtocol {
    let filename: String
    let fileType: String
    
    init(filename: String, fileType: String) {
        self.filename = filename
        self.fileType = fileType
    }

    func loadTimelineFeed() throws -> Timeline {
        guard let path = Bundle.main.url(forResource: filename, withExtension: fileType, subdirectory: nil) else {
            throw TimelineServiceError.filePathError
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Timeline.self, from: data)
                return result
            } catch {
                throw TimelineServiceError.decodingError
            }
        } catch {
            throw TimelineServiceError.dataConversionError
        }
    }
}
