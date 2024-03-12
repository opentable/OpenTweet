import Foundation

struct Tweet: Codable {
    let id: Int
    let author: String
    let avatarURL: URL?
    let content: String
    let date: Date
    let inReplyTo: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case avatarURL
        case content
        case date
        case inReplyTo
    }
    
    
}
