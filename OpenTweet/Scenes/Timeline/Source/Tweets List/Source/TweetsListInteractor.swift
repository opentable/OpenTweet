import Foundation

/// Used by the View Controller
protocol TweetsListBusinessLogic {
    func requestDetails(request: TweetsList.Details.Request)
    func requestTweets(request: TweetsList.Tweets.Request)
    func selectTweet(request: TweetsList.SelectTweet.Request)
}

/// Used by the Router
protocol TweetsListDataStore {
    var selectedTweet: Tweet? { get set }
    func resetSelectedTweet()
}

final class TweetsListInteractor: TweetsListDataStore {
    private let viewType: TweetsList.ViewType
    private var tweets: [Tweet]?
    
    var presenter: TweetsListPresentationLogic?
    var tweetsWorker: TweetsWorkable?
    
    var selectedTweet: Tweet?
    
    init(viewType: TweetsList.ViewType) {
        self.viewType = viewType
    }
    
    func resetSelectedTweet() {
        selectedTweet = nil
    }
}

extension TweetsListInteractor: TweetsListBusinessLogic {
    func requestDetails(request: TweetsList.Details.Request) {
        let response = TweetsList.Details.Response(viewType: viewType)
        presenter?.presentDetails(response: response)
    }
    
    func requestTweets(request: TweetsList.Tweets.Request) {
        /// If the view is timeline, fetch all of the tweets
        /// If the view is thread, fetch the tweets replied to the tweet
        tweets = {
            switch viewType {
            case .timeline:
                return try? tweetsWorker?.fetchTweets()
            case .thread(let tweet):
                /// If replied tweets exist, append them after the original tweet
                if let tweets = try? tweetsWorker?.fetchTweets(repliedTo: tweet.id) {
                    return [tweet] + tweets
                } else {
                    return [tweet]
                }
            }
        }()
        
        guard let tweets else { return }
        let response = TweetsList.Tweets.Response(tweets: tweets)
        presenter?.presentTweets(response: response)
    }
    
    func selectTweet(request: TweetsList.SelectTweet.Request) {
        let row = request.indexPath.row
        
        // If a thread is opened, don't open another one for the same tweet
        if case .thread = viewType, row == 0 {
            return
        }
        
        selectedTweet = tweets?.at(row)
    }
}
