import XCTest
@testable import OpenTweet

final class TweetsListPresenterTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_presenter_presentDetails() {
        let viewController = MockTweetsListViewController()
        var presenter = TweetsListPresenter()
        presenter.viewController = viewController
        
        presenter.presentDetails(response: .init(viewType: .timeline))
        XCTAssertEqual(viewController.displayDetailsCalledCount, 1)
        XCTAssertEqual(viewController.navigationTitle, "Timeline")
        
        presenter.presentDetails(response: .init(viewType: .thread(tweet: .testTweet())))
        XCTAssertEqual(viewController.displayDetailsCalledCount, 2)
        XCTAssertEqual(viewController.navigationTitle, "Thread")
    }
    
    func test_presenter_presentTweets() {
        let viewController = MockTweetsListViewController()
        var presenter = TweetsListPresenter()
        presenter.viewController = viewController
        
        presenter.presentTweets(response: .init(tweets: []))
        XCTAssertEqual(viewController.displayTweetsCalledCount, 1)
        XCTAssertNotNil(viewController.tweets)
        XCTAssertTrue(viewController.tweets?.isEmpty == true)
        
        let content = "@test check out this link https://www.opentable.ca nice work #test"
        let date = Date()
        let avatar = "https://www.opentable.ca"
        let tweet = Tweet.testTweet(content: content, date: date, avatar: avatar)
        presenter.presentTweets(response: .init(tweets: [tweet]))
        XCTAssertEqual(viewController.displayTweetsCalledCount, 2)
        XCTAssertNotNil(viewController.tweets)
        XCTAssertTrue(viewController.tweets?.count == 1)
        
        let tweetViewModel = (viewController.tweets?.first)!
        XCTAssertEqual(tweetViewModel.avatarImage.url, URL(string: avatar))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        let dateString = dateFormatter.string(from: date)
        let timeComponents = dateString.components(separatedBy: " ")
        XCTAssertEqual(tweetViewModel.date, "12-04-2023 at \(timeComponents[1]) \(timeComponents[2])")
        
        XCTAssertTrue(tweetViewModel.content.attributes(at: 6, effectiveRange: nil).isEmpty)
        
        XCTAssertFalse(tweetViewModel.content.attributes(at: 0, effectiveRange: nil).isEmpty)
        XCTAssertEqual(tweetViewModel.content.attributes(at: 0, effectiveRange: nil).keys.first, .foregroundColor)
        XCTAssertEqual(tweetViewModel.content.attributes(at: 0, effectiveRange: nil).values.first as! UIColor, UIColor.systemBlue)
        
        XCTAssertFalse(tweetViewModel.content.attributes(at: 26, effectiveRange: nil).isEmpty)
        XCTAssertEqual(tweetViewModel.content.attributes(at: 26, effectiveRange: nil).keys.first, .foregroundColor)
        XCTAssertEqual(tweetViewModel.content.attributes(at: 26, effectiveRange: nil).values.first as! UIColor, UIColor.systemBlue)
        
        XCTAssertFalse(tweetViewModel.content.attributes(at: 61, effectiveRange: nil).isEmpty)
        XCTAssertEqual(tweetViewModel.content.attributes(at: 61, effectiveRange: nil).keys.first, .foregroundColor)
        XCTAssertEqual(tweetViewModel.content.attributes(at: 61, effectiveRange: nil).values.first as! UIColor, UIColor.systemBlue)
    }
}
