import Foundation
@testable import OpenTweet

extension Tweet {
    static func testTweet(
        id: String = UUID().uuidString,
        author: String = "test_author",
        content: String = "Test",
        date: Date = Date(),
        avatar: String? = nil,
        inReplyTo: String? = nil
    ) -> Tweet {
        .init(id: id, author: author, content: content, date: Date(), avatar: avatar, inReplyTo: inReplyTo)
    }
}
