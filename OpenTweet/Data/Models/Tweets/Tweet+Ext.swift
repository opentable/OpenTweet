import Foundation

/// `Tweet` helper methods
extension Tweet {
    var contentMentionMatches: [NSTextCheckingResult]? {
        let mentionPattern = "@\\w+"
        let mentionRegex = try? NSRegularExpression(pattern: mentionPattern)
        return mentionRegex?.matches(in: content, range: .init(location: 0, length: content.count))
    }
    
    var contentHashtagMatches: [NSTextCheckingResult]? {
        let hashtagPattern = "#\\w+"
        let hashtagRegex = try? NSRegularExpression(pattern: hashtagPattern)
        return hashtagRegex?.matches(in: content, range: .init(location: 0, length: content.count))
    }
    
    var contentUrlMatches: [NSTextCheckingResult]? {
        let linkDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        return linkDetector?.matches(in: content, range: .init(location: 0, length: content.count))
    }
}
