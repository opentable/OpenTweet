//
//  ThreadViewController.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

final class ThreadViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case originalTweet
        case tweetRepliesTo
        case tweetReplies
        
        var headerText: String {
            switch self {
            case .originalTweet:
                return Constants.ThreadView.originalTweetHeaderTitle
            case .tweetRepliesTo:
                return Constants.ThreadView.tweetRepliesToHeaderTitle
            case .tweetReplies:
                return Constants.ThreadView.tweetRepliesHeaderTitle
            }
        }
    }
    
    private var viewModel: ThreadViewModelInterface
    private var dataSource: UICollectionViewDiffableDataSource<Section, Tweet>?
    
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
        section.interGroupSpacing = Constants.Dimens.padding
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constants.Dimens.padding,
            bottom: 0,
            trailing: Constants.Dimens.padding
        )
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(Constants.ThreadView.headerHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [header]
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(
            TweetCell.self,
            forCellWithReuseIdentifier: TweetCell.reuseIdentifier
        )
        collectionView.register(
            ThreadHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ThreadHeaderView.reuseIdentifier
        )
        collectionView.isUserInteractionEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(viewModel: ThreadViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.pinToSuperView()
        view.backgroundColor = .systemBackground
        title = Constants.ThreadView.title
        
        setupDataSource()
        applySnapshot()
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TweetCell.reuseIdentifier,
                for: indexPath
            ) as? TweetCell else {
                return UICollectionViewCell()
            }
            let tweetCellViewModel = TweetCellViewModel(tweet: itemIdentifier)
            cell.setup(tweetCellViewModel)
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { [weak self]
            (
                collectionView: UICollectionView,
                kind: String,
                indexPath: IndexPath)
            -> UICollectionReusableView? in
            guard let self = self else { return nil }

            let section = dataSource?.snapshot().sectionIdentifiers[indexPath.section]

            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ThreadHeaderView.reuseIdentifier,
                for: indexPath
            ) as? ThreadHeaderView else {
                return UICollectionReusableView()
            }

            let headerText = Section(rawValue: section?.rawValue ?? 0)?.headerText
            headerView.setup(text: headerText)
            return headerView
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>()
        
        snapshot.appendSections([.originalTweet])
        snapshot.appendItems([viewModel.tweet], toSection: .originalTweet)
        
        if let tweetRepliesTo = viewModel.tweet.tweetRepliesTo {
            snapshot.appendSections([.tweetRepliesTo])
            snapshot.appendItems([tweetRepliesTo], toSection: .tweetRepliesTo)
        } else if let tweetReplies = viewModel.tweet.tweetReplies {
            snapshot.appendSections([.tweetReplies])
            snapshot.appendItems(tweetReplies, toSection: .tweetReplies)
        }
        
        dataSource?.apply(snapshot)
    }
}
