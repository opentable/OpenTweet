//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit
import Combine

extension UICollectionViewLayout {
    static func createBasicListLayout() -> UICollectionViewLayout {
        let estimatedHeight: CGFloat = 100
        let width: NSCollectionLayoutDimension = .fractionalWidth(1)
        let itemSize = NSCollectionLayoutSize(widthDimension: width,
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: width,
                                               heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

class TimelineViewController: UIViewController {
    private let viewModel = TimelineViewModel()
    private var collectionViewCancellable: AnyCancellable?
    private var dataSource: UICollectionViewDiffableDataSource<Int, Tweet>?

    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .createBasicListLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(
            TweetCell.self,
            forCellWithReuseIdentifier: TweetCell.identifier
        )
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "OpenTweet"
        view.addSubview(collectionView)
        collectionView.pin(superView: view)

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TweetCell.identifier,
                for: indexPath
            ) as? TweetCell else {
                return UICollectionViewCell()
            }
            cell.configure(itemIdentifier)
            return cell
        })

        collectionViewCancellable = viewModel.$data
            .receive(on: RunLoop.main)
            .sink { [weak self] package in
                switch package {
                case .loading:
                    break
                case .loaded(tweets: let tweets):
                    var snapshot = NSDiffableDataSourceSnapshot<Int, Tweet>()
                    snapshot.appendSections([0])
                    snapshot.appendItems(tweets)
                    print(tweets)
                    self?.dataSource?.apply(snapshot)
                    break
                case .error:
                    break
                }
            }
    }
}
