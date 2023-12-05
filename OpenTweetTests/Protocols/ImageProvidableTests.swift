import XCTest
@testable import OpenTweet

private struct MockImageProvidable: ImageProvidable {}

final class ImageProvidableTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_imageIsDownloadedAndStored() {
        let imageUrl = URL(string: "https://picsum.photos/200")!
        MockImageProvidable().fetchImage(fromUrl: imageUrl) { image in
            XCTAssertNotNil(image)
            
            let fileManager = FileManager.default
            let cachesDirectoryUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
            let fileUrl = cachesDirectoryUrl?.appendingPathComponent(imageUrl.lastPathComponent)
            XCTAssertTrue(fileManager.fileExists(atPath: fileUrl!.path))
        }
    }
}
