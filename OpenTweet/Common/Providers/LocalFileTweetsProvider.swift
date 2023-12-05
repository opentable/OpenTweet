import Foundation

/// Provides the tweets by reading from a local file
protocol LocalFileTweetsProvidable {
    func fetchLocalFileTweets() throws -> [Tweet]
}

struct LocalFileTweetsProvider {
    private let bundle = Bundle.main
    private let resourceName = "timeline"
}

extension LocalFileTweetsProvider: LocalFileTweetsProvidable {
    func fetchLocalFileTweets() throws -> [Tweet] {
        guard let path = bundle.path(forResource: resourceName, ofType: "json") else {
            throw ApplicationError.localFileTweetsFetchingFailedDueToFileNotFound
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let data = try Data(contentsOf: .init(fileURLWithPath: path))
        let result = try decoder.decode(TweetsResponseObject.self, from: data)
        return result.timeline
    }
}
