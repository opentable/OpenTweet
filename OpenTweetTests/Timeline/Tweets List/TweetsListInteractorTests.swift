import XCTest
@testable import OpenTweet

final class TweetsListInteractorTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_interactor_requestDetails() {
        let presenter = MockTweetsListPresenter()
        
        var interactor = TweetsListInteractor(viewType: .timeline)
        interactor.presenter = presenter
        interactor.requestDetails(request: .init())
        
        XCTAssertEqual(presenter.presentDetailsCalledCount, 1)
        XCTAssertEqual(presenter.viewType, .timeline)
        
        let tweet = Tweet.testTweet()
        interactor = TweetsListInteractor(viewType: .thread(tweet: tweet))
        interactor.presenter = presenter
        interactor.requestDetails(request: .init())
        
        XCTAssertEqual(presenter.presentDetailsCalledCount, 2)
        XCTAssertEqual(presenter.viewType, .thread(tweet: tweet))
    }
    
    func test_interactor_requestTweets() {
        let presenter = MockTweetsListPresenter()
        
        var interactor = TweetsListInteractor(viewType: .timeline)
        interactor.presenter = presenter
        interactor.tweetsWorker = TweetsWorker(localTweetsProvider: LocalTweetsProvider(localFileTweetsProvider: MockLocalFileTweetsProvider(tweets: [])))
        interactor.requestTweets(request: .init())
        
        XCTAssertEqual(presenter.presentTweetsCalledCount, 1)
        XCTAssertNotNil(presenter.tweets)
        XCTAssertTrue(presenter.tweets?.isEmpty == true)
        
        let tweet = Tweet.testTweet()
        interactor = TweetsListInteractor(viewType: .timeline)
        interactor.presenter = presenter
        interactor.tweetsWorker = TweetsWorker(localTweetsProvider: LocalTweetsProvider(localFileTweetsProvider: MockLocalFileTweetsProvider(tweets: [tweet])))
        interactor.requestTweets(request: .init())
        
        XCTAssertEqual(presenter.presentTweetsCalledCount, 2)
        XCTAssertEqual(presenter.tweets, [tweet])
        
        interactor = TweetsListInteractor(viewType: .thread(tweet: tweet))
        interactor.presenter = presenter
        interactor.tweetsWorker = TweetsWorker(localTweetsProvider: LocalTweetsProvider(localFileTweetsProvider: MockLocalFileTweetsProvider(tweets: [])))
        interactor.requestTweets(request: .init())
        
        XCTAssertEqual(presenter.presentTweetsCalledCount, 3)
        XCTAssertEqual(presenter.tweets, [tweet])
        
        let repliedTweet = Tweet.testTweet(inReplyTo: tweet.id)
        let tweets = [tweet, repliedTweet, Tweet.testTweet(), Tweet.testTweet(inReplyTo: "test")]
        interactor = TweetsListInteractor(viewType: .thread(tweet: tweet))
        interactor.presenter = presenter
        interactor.tweetsWorker = TweetsWorker(localTweetsProvider: LocalTweetsProvider(localFileTweetsProvider: MockLocalFileTweetsProvider(tweets: tweets)))
        interactor.requestTweets(request: .init())
        
        XCTAssertEqual(presenter.presentTweetsCalledCount, 4)
        XCTAssertEqual(presenter.tweets, [tweet, repliedTweet])
    }
    
    func test_interactor_selectTweet() {
        let presenter = MockTweetsListPresenter()
        
        var interactor = TweetsListInteractor(viewType: .timeline)
        interactor.presenter = presenter
        interactor.tweetsWorker = TweetsWorker(localTweetsProvider: LocalTweetsProvider(localFileTweetsProvider: MockLocalFileTweetsProvider(tweets: [])))
        interactor.selectTweet(request: .init(indexPath: .init(row: 0, section: 0)))
        
        XCTAssertNil(interactor.selectedTweet)
        
        let tweet = Tweet.testTweet()
        let tweets = [tweet, Tweet.testTweet(inReplyTo: tweet.id)]
        interactor = TweetsListInteractor(viewType: .timeline)
        interactor.presenter = presenter
        interactor.tweetsWorker = TweetsWorker(localTweetsProvider: LocalTweetsProvider(localFileTweetsProvider: MockLocalFileTweetsProvider(tweets: tweets)))
        interactor.requestTweets(request: .init())
        interactor.selectTweet(request: .init(indexPath: .init(row: 1, section: 0)))
        
        XCTAssertEqual(interactor.selectedTweet, tweets.last)
        
        interactor = TweetsListInteractor(viewType: .thread(tweet: tweets[0]))
        interactor.presenter = presenter
        interactor.tweetsWorker = TweetsWorker(localTweetsProvider: LocalTweetsProvider(localFileTweetsProvider: MockLocalFileTweetsProvider(tweets: tweets)))
        interactor.requestTweets(request: .init())
        interactor.selectTweet(request: .init(indexPath: .init(row: 0, section: 0)))
        
        XCTAssertNil(interactor.selectedTweet)
        
        interactor.selectTweet(request: .init(indexPath: .init(row: 1, section: 0)))
        
        XCTAssertEqual(interactor.selectedTweet, tweets.last)
    }
}
