import Foundation
import Alamofire

/// Custom failure type only for parsing individual tweet.
enum DecodableFailed: Error {
    case invalidRequiredParameter
}

/// Individual tweet model.
struct Tweet: Decodable, Identifiable {
    let id: Int
    let author: String
    let avatarURL: URL?
    let content: String
    let date: Date
    let inReplyTo: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case avatar
        case content
        case date
        case inReplyTo
    }
    
    /**
     Ensures JSON String type is converted to primitive types of model.
     
     - Parameters:
         - decoder: A Decoder.
     - Fixme: If this function throws for one tweet, `ResponseData` becomes empty.
     - Returns: An attributed string with mentions highlighted.
     */
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let idText = try container.decode(String.self, forKey: .id)
        
        guard let idPrimitive = Int(idText) else {
            throw DecodableFailed.invalidRequiredParameter
        }
        
        self.id = idPrimitive
        self.author = try container.decode(String.self, forKey: .author)
        self.content = try container.decode(String.self, forKey: .content)
        self.date = try container.decode(Date.self, forKey: .date)
        
        if let url = try container.decodeIfPresent(URL.self, forKey: .avatar) {
            self.avatarURL = url
        } else {
            self.avatarURL = nil
        }
        
        if let inReplyToText = try container.decodeIfPresent(String.self, forKey: .inReplyTo) {
            self.inReplyTo = Int(inReplyToText)
        } else {
            self.inReplyTo = nil
        }
    }
}
