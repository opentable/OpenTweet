import XCTest
@testable import OpenTweet

final class CollectionExtensionTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_collectionIndex() {
        let collection = [1, 3, 7, 9]
        XCTAssertEqual(collection.at(3), 9)
        XCTAssertNil(collection.at(5))
    }
}
