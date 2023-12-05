@testable import OpenTweet

final class MockTweetsListViewController: TweetsListDisplayLogic {
    var displayDetailsCalledCount = 0
    var navigationTitle: String?
    var displayTweetsCalledCount = 0
    var tweets: [TweetTableViewCellViewModel]?
    
    func displayDetails(viewModel: TweetsList.Details.ViewModel) {
        displayDetailsCalledCount += 1
        navigationTitle = viewModel.navigationTitle
    }
    
    func displayTweets(viewModel: TweetsList.Tweets.ViewModel) {
        displayTweetsCalledCount += 1
        tweets = viewModel.tweets
    }
}
