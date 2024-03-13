//
//  TimelineViewController.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-11.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit
import Combine

final class TimelineViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case feed
    }
    private var viewModel: TimelineViewModelInterface
    private var dataSource: UICollectionViewDiffableDataSource<Section, Tweet>?
    private var cancellables = Set<AnyCancellable>()

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
            TweetCell.self,
            forCellWithReuseIdentifier: TweetCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(viewModel: TimelineViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservers()
        viewModel.loadTimelineFeed()
        view.addSubview(collectionView)
        collectionView.pinToSuperView()
        view.backgroundColor = .systemBackground
        title = "Timeline"
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TweetCell.reuseIdentifier,
                for: indexPath
            ) as? TweetCell else {
                return UICollectionViewCell()
            }
            cell.setup(tweet: itemIdentifier)
            cell.layoutIfNeeded()
            return cell
        })
    }

    private func setupObservers() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feedState in
                guard let self = self else { return }
                switch feedState {
                case .loading:
                    print("loading")
                case .loaded(timeline: let timeline):
                    self.feedLoaded(timeline: timeline)
                case .error(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func feedLoaded(timeline: [Tweet]) {
        self.setupDataSource()
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>()
        snapshot.appendSections([.feed])
        snapshot.appendItems(timeline, toSection: .feed)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension TimelineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TweetCell else {
            return
        }
        cell.onCellTapped = { [weak self] in
            guard let self = self else { return }
            guard let tweet = self.dataSource?.snapshot().itemIdentifiers[indexPath.item] else {
                return
            }
            viewModel.tappedOn(tweet: tweet)
        }
    }
}
