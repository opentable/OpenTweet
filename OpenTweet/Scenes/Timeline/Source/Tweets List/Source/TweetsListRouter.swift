import UIKit

/// Used by the view controller to route to another screens
protocol TweetsListRoutingLogic {
    func routeToSelectedTweetThread()
}

struct TweetsListRouter {
    weak var viewController: TweetsListViewController?
    var dataStore: TweetsListDataStore?
}

extension TweetsListRouter: TweetsListRoutingLogic {
    func routeToSelectedTweetThread() {
        guard let selectedTweet = dataStore?.selectedTweet else {
            return
        }
        viewController?.navigationController?.pushViewController(TweetsList.scene(withType: .thread(tweet: selectedTweet)), animated: true)
        dataStore?.resetSelectedTweet()
    }
}
