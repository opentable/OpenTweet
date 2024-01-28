//
//  TweetDetailViewController.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-27.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit
import Combine

final class TweetDetailViewController: UIViewController {
    private lazy var headerView: UIView = UIView()
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var avatarImageView: UIImageView = UIImageView()
    
    private lazy var tweetDetailViewModel = TweetDetailViewModel(tweet: mainTweet)
    private var dataSource: UICollectionViewDiffableDataSource<Int, Tweet>?
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var tweetDetailView: TweetDetailView = {
        let view = TweetDetailView(configurer: tweetDetailViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainTweet: Tweet
    

    init(tweet: Tweet) {
        self.mainTweet = tweet
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetDetailView.collectionView.delegate = self
        setupNavigationBackButton()
        setupHeaderView()
        view.backgroundColor = .systemBackground
        view.addSubview(tweetDetailView)
        tweetDetailView.pinToSuperView(shouldPinToSafeArea: true)
        configureDataSource()
        applySnapshot()
    }
}

extension TweetDetailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Adjust the alpha (transparency) of the title label and logo image view based on the scrolling offset
        let offsetY = scrollView.contentOffset.y
        let maxOffsetY: CGFloat = 100
        let alpha = min(1, max(0, offsetY / maxOffsetY))
        
        // Update title label and logo image view alpha
        titleLabel.alpha = 1.0 - alpha
        avatarImageView.alpha = alpha
    }
}

private extension TweetDetailViewController {
    func setupNavigationBackButton() {
        // Create a custom back button with "Back" text
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("OpenTweet", for: .normal)
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 8)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // Create a custom view with the back button and text
        let customBackButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        backButton.frame = customBackButtonView.bounds
        customBackButtonView.addSubview(backButton)

        // Create a custom bar button item with the custom view
        let customBackButtonItem = UIBarButtonItem(customView: customBackButtonView)

        // Assign the custom back button item to the left bar button item
        navigationItem.leftBarButtonItem = customBackButtonItem
    }
    
    func setupHeaderView() {
        // Create a header view with a title label and an avatar image view
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = mainTweet.author
        titleLabel.font = .boldSystemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        titleLabel.alpha = 1.0 // Initially fully opaque
        headerView.addSubview(titleLabel)

        avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = mainTweet.avatar {
            avatarImageView.loadImageFromURL(urlString: url)
        } else {
            avatarImageView.image = AvatarGenerator.generateAvatarImage(
                forUsername: mainTweet.author,
                size: Constants.Dimens.imageSizeNavigationBar
            )
        }
        avatarImageView.makeRoundedCornerOfRadius(radius: Constants.Dimens.imageSizeNavigationBar.width / 2)
        avatarImageView.alpha = 0.0 // initially fully transparent
        headerView.addSubview(avatarImageView)

        // Center both the title label and avatar image view horizontally in the header view
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.Dimens.imageSizeNavigationBar.width),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.Dimens.imageSizeNavigationBar.height)
        ])
        // Add the header view to the navigation bar
        navigationItem.titleView = headerView
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: tweetDetailView.collectionView, cellProvider: { collectionView, indexPath, tweet in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TweetReplyCell.identifier,
                for: indexPath
            ) as? TweetReplyCell else {
                return UICollectionViewCell()
            }
            
            var replyTweet: Tweet?
            if !tweet.tweetReplies.isEmpty {
                replyTweet = tweet.tweetReplies[0]
            }
            
            let viewModel = TweetReplyViewModel(mainTweet: tweet, replyTweet: replyTweet)
            cell.setup(tweetConfigurer: viewModel)
            return cell
        })
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Tweet>()
        snapshot.appendSections([0])
        snapshot.appendItems(mainTweet.tweetReplies)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
