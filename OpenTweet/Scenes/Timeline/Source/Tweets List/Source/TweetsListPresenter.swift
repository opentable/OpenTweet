import UIKit

/// Used by the Interactor
protocol TweetsListPresentationLogic {
    func presentDetails(response: TweetsList.Details.Response)
    func presentTweets(response: TweetsList.Tweets.Response)
}

struct TweetsListPresenter {
    weak var viewController: TweetsListDisplayLogic?
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy 'at' h:mm a"
        return dateFormatter
    }()
    
    private func tweetTableViewCellViewModel(fromTweets tweets: [Tweet]) -> [TweetTableViewCellViewModel] {
        tweets.map { tweet in
            let avatarImageUrl: URL? = {
                guard let avatar = tweet.avatar else {
                    return nil
                }
                return URL(string: avatar)
            }()
            
            let attributedContent: NSAttributedString = {
                let attributedString = NSMutableAttributedString(string: tweet.content)
                var matches = [NSTextCheckingResult]()

                if let mentionMatches = tweet.contentMentionMatches {
                    matches.append(contentsOf: mentionMatches)
                }

                if let hashtagMatches = tweet.contentHashtagMatches {
                    matches.append(contentsOf: hashtagMatches)
                }
                
                if let urlMatches = tweet.contentUrlMatches {
                    matches.append(contentsOf: urlMatches)
                }
                
                matches.forEach({ result in
                    attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: result.range)
                })
                return attributedString
            }()
            
            return .init(
                author: tweet.author,
                avatarImage: .init(url: avatarImageUrl, placeholderImage: UIImage(named: "user")),
                content: attributedContent,
                date: dateFormatter.string(from: tweet.date)
            )
        }
    }
}

extension TweetsListPresenter: TweetsListPresentationLogic {
    func presentDetails(response: TweetsList.Details.Response) {
        let navigationTitle: String = {
            switch response.viewType {
            case .timeline:
                return .timeline
            case .thread:
                return .thread
            }
        }()
        let viewModel = TweetsList.Details.ViewModel(navigationTitle: navigationTitle)
        viewController?.displayDetails(viewModel: viewModel)
    }
    
    func presentTweets(response: TweetsList.Tweets.Response) {
        let viewModel = TweetsList.Tweets.ViewModel(tweets: tweetTableViewCellViewModel(fromTweets: response.tweets))
        viewController?.displayTweets(viewModel: viewModel)
    }
}
