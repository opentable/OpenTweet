import Foundation

typealias UserID = String

struct Timeline: Decodable {
    var timeline: [Tweet]
}

struct Thread {
    var root: Tweet?
    var tweets: [Tweet]
}

struct Tweet {
    // Opaque type so consumers don't have to know / care
    typealias ID = Int

    var id: ID
    var author: UserID
    var content: String
    var date: Date
    var avatar: URL?
    var inReplyTo: ID?
    var images: [URL]?
}

extension Tweet: Decodable {
    enum Error: Swift.Error {
        case badDateFormat(String)
        case badIDData(String)
    }

    enum CodingKeys: CodingKey {
        case id, author, content, date, avatar, inReplyTo, images
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let idString = try container.decode(String.self, forKey: .id)
        guard let id = Int(idString)
        else { throw Error.badIDData(idString) }
        self.id = id

        self.author = try container.decode(UserID.self, forKey: .author)
        self.content = try container.decode(String.self, forKey: .content)

        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString)
        else { throw Error.badDateFormat(dateString) }
        self.date = date

        self.avatar = try container.decodeIfPresent(URL.self, forKey: .avatar)
        if let inReplyToString = try container.decodeIfPresent(String.self, forKey: .inReplyTo) {
            self.inReplyTo = Int(inReplyToString)
        }
        self.images = try container.decodeIfPresent([URL].self, forKey: .images)
    }
}

extension Array where Element == Tweet {
    func sortedByDate() -> Self {
        return sorted { $0.date < $1.date }
    }
}
