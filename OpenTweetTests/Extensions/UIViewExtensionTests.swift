import XCTest
@testable import OpenTweet

final class UIViewExtensionTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_viewNibName() {
        XCTAssertEqual(TweetTableViewCell.nibName, "TweetTableViewCell")
    }
}
