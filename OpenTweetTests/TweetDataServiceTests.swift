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
    
    // MARK: Replies
    
    func testLoadTweetRepliesWithValidData() async {
        let jsonData = """
            {
                "timeline": [
                    {
                        "id": "00001",
                        "author": "@randomInternetStranger",
                        "content": "Man, I'm hungry. I probably should book a table at a restaurant or something. Wonder if there's an app for that?",
                        "avatar": "https://i.imgflip.com/ohrrn.jpg",
                        "date": "2020-09-29T14:41:00-08:00",
                        "inReplyTo": null
                    },
                    {
                        "id": "00002",
                        "author": "@anotherRandomStranger",
                        "content": "Sure, there are plenty of apps for that. I can recommend a few!",
                        "avatar": "https://i.imgflip.com/ohrrn.jpg",
                        "date": "2020-09-29T14:45:00-08:00",
                        "inReplyTo": "00001"
                    }
                ]
            }
        """.data(using: .utf8)
        mockBundle.mockJSONData = jsonData
        
        do {
            let tweetReplies = try await tweetDataService.loadTweetReplies(tweetId: "00001")
            XCTAssertFalse(tweetReplies.isEmpty, "Loaded tweet replies should not be empty")
            XCTAssertEqual(tweetReplies[0].content, "Sure, there are plenty of apps for that. I can recommend a few!")
        } catch {
            XCTFail("Unexpected error while loading tweet replies: \(error)")
        }
    }
    
    func testLoadTweetRepliesWithInvalidData() async {
        let jsonData = """
            {
                "timeline": [
                    {
                        "id": "00001",
                        "author": "@randomInternetStranger",
                        "content": "Man, I'm hungry. I probably should book a table at a restaurant or something. Wonder if there's an app for that?",
                        "avatar": "https://i.imgflip.com/ohrrn.jpg",
                        "date": "2020-09-29T14:41:00-08:00",
                        "inReplyTo": null
                    },
                    {
                        "id": "00002",
                        "author": "@anotherRandomStranger",
                        "content": "Sure, there are plenty of apps for that. I can recommend a few!",
                        "avatar": "https://i.imgflip.com/ohrrn.jpg",
                        "date": "2020-09-29T14:45:00-08:00",
                        "inReplyTo": "00003"
                    }
                ]
            }
        """.data(using: .utf8)
        mockBundle.mockJSONData = jsonData
        
        do {
            let tweetReplies = try await tweetDataService.loadTweetReplies(tweetId: "00001")
            XCTAssertTrue(tweetReplies.isEmpty, "Loaded tweet replies should be empty")
        } catch {
            XCTFail("Unexpected error while loading tweet replies: \(error)")
        }
    }
    
    // MARK: User
    
    func testLoadUserTweetsWithValidData() async {
        let jsonData = """
            {
                "timeline": [
                    {
                        "id": "00001",
                        "author": "@randomInternetStranger",
                        "content": "Man, I'm hungry. I probably should book a table at a restaurant or something. Wonder if there's an app for that?",
                        "avatar": "https://i.imgflip.com/ohrrn.jpg",
                        "date": "2020-09-29T14:41:00-08:00"
                    },
                    {
                        "id": "00002",
                        "author": "@anotherRandomStranger",
                        "content": "Sure, there are plenty of apps for that. I can recommend a few!",
                        "avatar": "https://i.imgflip.com/ohrrn.jpg",
                        "date": "2020-09-29T14:45:00-08:00"
                    },
                    {
                        "id": "00003",
                        "author": "@yourUsername",
                        "content": "Just booked a table at my favorite restaurant! Can't wait to eat there.",
                        "avatar": "https://youravatar.jpg",
                        "date": "2020-09-29T15:00:00-08:00"
                    }
                ]
            }
        """.data(using: .utf8)
        mockBundle.mockJSONData = jsonData
        
        do {
            let userTweets = try await tweetDataService.loadUserTweets(userName: "@yourUsername")
            XCTAssertFalse(userTweets.isEmpty, "Loaded user tweets should not be empty")
            XCTAssertEqual(userTweets[0].content, "Just booked a table at my favorite restaurant! Can't wait to eat there.")
        } catch {
            XCTFail("Unexpected error while loading user tweets: \(error)")
        }
    }
    
    func testLoadUserTweetsWithInvalidData() async {
        let jsonData = """
            {
                "timeline": [
                    {
                        "id": "00001",
                        "author": "@randomInternetStranger",
                        "content": "Man, I'm hungry. I probably should book a table at a restaurant or something. Wonder if there's an app for that?",
                        "avatar": "https://i.imgflip.com/ohrrn.jpg",
                        "date": "2020-09-29T14:41:00-08:00"
                    },
                    {
                        "id": "00002",
                        "author": "@anotherRandomStranger",
                        "content": "Sure, there are plenty of apps for that. I can recommend a few!",
                        "avatar": "https://i.imgflip.com/ohrrn.jpg",
                        "date": "2020-09-29T14:45:00-08:00"
                    },
                    {
                        "id": "00003",
                        "author": "@yourUsername",
                        "content": "Just booked a table at my favorite restaurant! Can't wait to eat there.",
                        "avatar": "https://youravatar.jpg",
                        "date": "2020-09-29T15:00:00-08:00"
                    }
                ]
            }
        """.data(using: .utf8)
        mockBundle.mockJSONData = jsonData
        
        do {
            let userTweets = try await tweetDataService.loadUserTweets(userName: "@landonr")
            XCTAssertTrue(userTweets.isEmpty, "Loaded user tweets should be empty")
        } catch {
            XCTFail("Unexpected error while loading user tweets: \(error)")
        }
    }
}

