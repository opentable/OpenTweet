import Foundation

/// Representation of the `Tweet` object
struct Tweet: Decodable, Equatable {
    let id: String
    let author: String
    let content: String
    let date: Date
    
    let avatar: String?
    let inReplyTo: String?
}
