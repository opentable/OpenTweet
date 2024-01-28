import XCTest
@testable import OpenTweet

class UIImageViewExtensionTests: XCTestCase {

    class MockURLSession: URLSession {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            let task = MockURLSessionDataTask {
                completionHandler(self.data, self.response, self.error)
            }
            return task
        }
    }

    class MockURLSessionDataTask: URLSessionDataTask {
        private let closure: () -> Void

        init(closure: @escaping () -> Void) {
            self.closure = closure
        }

        override func resume() {
            closure()
        }
    }

    var imageView: UIImageView!
    var mockURLSession: MockURLSession!

    override func setUp() {
        super.setUp()
        imageView = UIImageView()
        mockURLSession = MockURLSession()
    }

    override func tearDown() {
        imageView = nil
        mockURLSession = nil
        imageCache.removeAllObjects()
        super.tearDown()
    }

    func testLoadImageFromURL_WithSystemIcon() {
        // Given
        let systemIconName = "pencil"
        let systemIconImage = UIImage(systemName: systemIconName)
        let imageURL = "https://example.com/image.jpg"
        mockURLSession.data = systemIconImage?.pngData()

        let expectation = self.expectation(description: "Image loaded successfully")
        // When
        let task = imageView.loadImageFromURL(urlString: imageURL, placeholder: UIImage(named: "logo-image"), urlSession: mockURLSession) {
            expectation.fulfill()
        }
        
        // Then
        XCTAssertNotNil(task, "Expected data task to be created")
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
            // After the expectation is fulfilled, imageView should not have placeholder image
            XCTAssertNotEqual(self.imageView.image, UIImage(named: "logo-image"))
        }
    }

    func testLoadImageFromURL_WithPlaceholder() {
        // Given
        let placeholderImage = UIImage(named: "logo-image")
        let imageURL = "https://example.com/image.jpg"
        mockURLSession.data = placeholderImage?.pngData()

        // When
        let task = imageView.loadImageFromURL(urlString: imageURL, placeholder: placeholderImage, urlSession: mockURLSession)

        // Then
        XCTAssertNotNil(task, "Expected data task to be created")
        XCTAssertEqual(imageView.image, placeholderImage, "Expected logo image to be set")
    }

    func testImageCache() {
        // Given
        let imageURL = "https://example.com/image.jpg"
        let cachedImage = UIImage(named: "cachedImage")
        mockURLSession.data = cachedImage?.pngData()
        mockURLSession.response = HTTPURLResponse(url: URL(string: imageURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)

        // When
        let task = imageView.loadImageFromURL(urlString: imageURL, urlSession: mockURLSession)

        // Then
        XCTAssertNotNil(task, "Expected data task to be created")
        XCTAssertEqual(imageView.image, cachedImage, "Expected cached image to be set")

        // Additional assertion for imageCache
        let cacheKey = NSString(string: imageURL)
        let cachedImageFromCache = imageCache.object(forKey: cacheKey)
        XCTAssertEqual(cachedImageFromCache, cachedImage, "Expected image to be cached in imageCache")
    }
}
