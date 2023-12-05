@testable import OpenTweet

final class MockTweetsListPresenter: TweetsListPresentationLogic {
    var presentDetailsCalledCount = 0
    var viewType: TweetsList.ViewType?
    var presentTweetsCalledCount = 0
    var tweets: [Tweet]?
    
    func presentDetails(response: OpenTweet.TweetsList.Details.Response) {
        presentDetailsCalledCount += 1
        viewType = response.viewType
    }
    
    func presentTweets(response: OpenTweet.TweetsList.Tweets.Response) {
        presentTweetsCalledCount += 1
        tweets = response.tweets
    }
}
