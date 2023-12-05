import Foundation

/// Object containing list of tweets
struct TweetsResponseObject: Decodable {
    let timeline: [Tweet]
}
