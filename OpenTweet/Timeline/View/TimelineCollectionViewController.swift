//
//  TimelineCollectionViewController.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TweetViewCell"

class TimelineCollectionViewController: UICollectionViewController {

    private var viewModel = TimelineCollectionPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Timeline"
        collectionView.collectionViewLayout = CustomLayout()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TweetViewCell else { return UICollectionViewCell() }

        // Configure the cell
        cell.setup(with: viewModel.getTweet(at: indexPath.row), isSelected: viewModel.selectedRow == indexPath.row)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.select(row: indexPath.row)
        collectionView.reloadData()
    }
}
