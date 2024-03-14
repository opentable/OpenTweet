//
//  ThreadViewController.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit
import Combine

class ThreadViewController: UIViewController {
  
  private var viewModel: ThreadViewModel
  private var dataSource: UICollectionViewDiffableDataSource<Int, Tweet>?
  private var subscriptions = Set<AnyCancellable>()
  
  private let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.identifier)
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  private let activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    return activityIndicator
  }()
  
  init(viewModel: ThreadViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Thread"
    
    view.backgroundColor = .systemBackground
    view.addSubview(collectionView)
    view.addSubview(activityIndicator)
    
    setupConstraints()
    setupObservers()
    setupDataSource()
    
    viewModel.fetchThread()
  }
}

private extension ThreadViewController {
  func setupConstraints() {
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
  
  func setupObservers() {
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        switch state {
        case .loading:
          self?.activityIndicator.isHidden = false
        case .success(let tweets):
          self?.activityIndicator.isHidden = true
          var snapshot = NSDiffableDataSourceSnapshot<Int, Tweet>()
          snapshot.appendSections([0])
          snapshot.appendItems(tweets)
          self?.dataSource?.apply(snapshot, animatingDifferences: true)
        case .error(let error):
          self?.activityIndicator.isHidden = true
          print(error)
          //TODO - show error
        default:
          break
        }
      }
      .store(in: &subscriptions)
  }
  
  func setupDataSource() {
    dataSource = UICollectionViewDiffableDataSource(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, itemIdentifier in
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: TweetCell.identifier,
          for: indexPath
        ) as? TweetCell else {
          return UICollectionViewCell()
        }
        cell.configure(tweet: itemIdentifier)
        return cell
      })
    collectionView.dataSource = dataSource
  }
  
  static func createCollectionViewLayout() -> UICollectionViewLayout {
    let estimatedHeight: CGFloat = 120
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeight)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
    return UICollectionViewCompositionalLayout(section: section)
  }
}
