//
//  TimelineViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit
import Combine

final class TimelineViewController: UIViewController {

    private var headerView: UIView!
    private var titleLabel: UILabel!
    private var logoImageView: UIImageView!
    
    private lazy var viewModel = TimelineViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Int, Tweet>?
    private var subscriptions: Set<AnyCancellable> = []

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let estimatedHeight: CGFloat = 100
        let width: NSCollectionLayoutDimension = .fractionalWidth(1)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: width,
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: width,
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(
            TweetViewCell.self,
            forCellWithReuseIdentifier: TweetViewCell.identifier
        )
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        collectionView.addInteraction(contextMenuInteraction)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        view.backgroundColor = .systemBackground
        setupHeaderView()
        view.addSubview(collectionView)
        collectionView.pinToSuperView()
        configureDataSource()
        reloadData()
        // Set up scroll view delegate for parallax effect
        collectionView.delegate = self
    }
}

extension TimelineViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Adjust the alpha (transparency) of the title label and logo image view based on the scrolling offset
        let offsetY = scrollView.contentOffset.y
        let maxOffsetY: CGFloat = 100
        let alpha = min(1, max(0, offsetY / maxOffsetY))
        
        // Update title label and logo image view alpha
        titleLabel.alpha = 1.0 - alpha
        logoImageView.alpha = alpha
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedTweet = getTweetFromDataSource(at: indexPath) else {
            return
        }

        let viewController = TweetDetailViewController(tweet: selectedTweet)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TimelineViewController: UIContextMenuInteractionDelegate {

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = collectionView.indexPathForItem(at: location) else {
            return nil
        }

        guard let tweet = getTweetFromDataSource(at: indexPath) else {
            return nil
        }
        
        // Creates a preview view controller to show a tweet in details
        let previewViewController = TweetDetailViewController(tweet: tweet)
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: {
            
            // Shows the preview view controller when long pressing the cell
            return previewViewController
        }) { _ in
            
            // Defines menu items or actions related to the cell
            let visitAction = UIAction(title: "View \(tweet.author)'s tweet", image: nil) { [weak self] _ in
                self?.navigationController?.pushViewController(previewViewController, animated: true)
            }

            return UIMenu(title: "Actions", children: [visitAction])
        }
    }
}


private extension TimelineViewController {
    func getTweetFromDataSource(at indexPath: IndexPath) -> Tweet? {
        guard let tweet = dataSource?.itemIdentifier(for: indexPath) else {
            return nil
        }
        return tweet
    }
    
    func setupHeaderView() {
        // Create a header view with a title label and an image view for the logo
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "OpenTweet"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.alpha = 1.0 // Initially fully opaque
        headerView.addSubview(titleLabel)
        titleLabel.pinToSuperView()
        titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo-image")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.alpha = 0.0 // Initially fully transparent
        headerView.addSubview(logoImageView)
        logoImageView.pinToSuperView()
        logoImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        // Add the header view to the navigation bar
        navigationItem.titleView = headerView
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, tweet in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TweetViewCell.identifier,
                for: indexPath
            ) as? TweetViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = TweetViewModel(tweet: tweet)
            cell.setup(tweetConfigurer: viewModel)
            return cell
        })
    }
    
    func reloadData() {
        viewModel.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tweets in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Tweet>()
                snapshot.appendSections([0])
                snapshot.appendItems(tweets)
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &subscriptions)
        
        viewModel.fetchTweets()
    }
}

