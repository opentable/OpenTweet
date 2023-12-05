import UIKit

/// Used by the Presenter
protocol TweetsListDisplayLogic: AnyObject {
    func displayDetails(viewModel: TweetsList.Details.ViewModel)
    func displayTweets(viewModel: TweetsList.Tweets.ViewModel)
}

final class TweetsListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var interactor: TweetsListBusinessLogic?
    var router: TweetsListRoutingLogic?
    
    private var tweets: [TweetTableViewCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = true
        
        tableView.register(cell: TweetTableViewCell.self)
        
        interactor?.requestDetails(request: .init())
        interactor?.requestTweets(request: .init())
    }
}

extension TweetsListViewController: TweetsListDisplayLogic {
    func displayDetails(viewModel: TweetsList.Details.ViewModel) {
        title = viewModel.navigationTitle
    }
    
    func displayTweets(viewModel: TweetsList.Tweets.ViewModel) {
        tweets = viewModel.tweets
        tableView.reloadData()
    }
}

extension TweetsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetTableViewCell = tableView.dequeue(cell: TweetTableViewCell.self, for: indexPath)
        
        if let info = tweets.at(indexPath.row) {
            tweetTableViewCell.configure(withInfo: info)
        }
        
        return tweetTableViewCell
    }
}

extension TweetsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor?.selectTweet(request: .init(indexPath: indexPath))
        router?.routeToSelectedTweetThread()
    }
}
