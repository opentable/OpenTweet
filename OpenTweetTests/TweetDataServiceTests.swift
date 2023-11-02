//
//  TweetDataServiceTests.swift
//  OpenTweetTests
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import XCTest

final class TweetDataServiceTests: XCTestCase {
    
    var tweetDataService: TweetDataService!
    var mockBundle: MockBundle!
    
    override func setUpWithError() throws {
        mockBundle = MockBundle()
        tweetDataService = TweetDataService(bundle: mockBundle)
    }

    override func tearDownWithError() throws {
        tweetDataService = nil
    }
    
    func testLoadTweetsWithValidData() async {
        let jsonData = """
            {
                "timeline": [
                    {
                        "id": "00001",
                        "author": "@randomInternetStranger",
                        "content": "Man, I'm hungry. I probably should book a table at a restaurant or something. Wonder if there's an app for that?",
                        "avatar": "https://i.imgflip.com/ohrrn.jpg",
                        "date": "2020-09-29T14:41:00-08:00"
                    }
                ]
            }
        """.data(using: .utf8)
        mockBundle.mockJSONData = jsonData
        
        do {
            let tweets = try await tweetDataService.loadTweets()
            XCTAssertFalse(tweets.isEmpty, "Loaded tweets should not be empty")
        } catch {
            XCTFail("Unexpected error while loading tweets: \(error)")
        }
    }
    
    func testLoadTweetsWithInvalidData() async {
        // id is missing
        let jsonData = """
            {
                "timeline": [
                    {
                        "author": "@randomInternetStranger",
                        "content": "Man, I'm hungry. I probably should book a table at a restaurant or something. Wonder if there's an app for that?",
                        "avatar": "https://i.imgflip.com/ohrrn.jpg",
                        "date": "2020-09-29T14:41:00-08:00"
                    }
                ]
            }
        """.data(using: .utf8)
        mockBundle.mockJSONData = jsonData
        
        do {
            _ = try await tweetDataService.loadTweets()
            XCTFail("Expected an error when loading tweets")
        } catch let error as API.APIError {
            XCTAssertEqual(error, .decodingError(description: ""), "Expected APIError.decodingError")
        } catch {
            XCTFail("Unexpected error while loading tweets: \(error)")
        }
    }

    func testLoadTweetsWithMissingData() async {
        // Simulate a case where the file is not found
        mockBundle.mockJSONData = nil
        do {
            _ = try await tweetDataService.loadTweets()
            XCTFail("Expected an error when loading tweets")
        } catch let error as API.APIError {
            XCTAssertEqual(error, .fileNotFound, "Expected APIError.fileNotFound")
        } catch {
            XCTFail("Unexpected error while loading tweets: \(error)")
        }
    }
}

