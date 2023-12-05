import Foundation

/// Use cases
enum TweetsList {
    enum ViewType: Equatable {
        case timeline, thread(tweet: Tweet)
    }
    
    enum Details {
        struct Request {}
        struct Response {
            let viewType: ViewType
        }
        struct ViewModel {
            let navigationTitle: String
        }
    }
    
    enum Tweets {
        struct Request {}
        struct Response {
            let tweets: [Tweet]
        }
        struct ViewModel {
            let tweets: [TweetTableViewCellViewModel]
        }
    }
    
    enum SelectTweet {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
}
