//
//  TimelineViewController.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/15/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    // MARK: - Properties
    
    let timelineTableView: TimelineTableView = {
        let tv = TimelineTableView()
        return tv
    }()
    
    // MARK: - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
    }

    // MARK: - Helper Functions

    private func configureTableView() {
        timelineTableView.transitionToTimelineDetailViewControllerDelegate = self
        timelineTableView.transitionToUserProfileViewControllerDelegate = self
        timelineTableView.alertDelegate = self
        
        view.addSubview(timelineTableView)
        timelineTableView.anchorWithConstant(top: view.safeAreaLayoutGuide.topAnchor,
                                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                             leading: view.leadingAnchor,
                                             trailing: view.trailingAnchor,
                                             paddingTop: 0,
                                             paddingBottom: 0,
                                             paddingLeading: 0,
                                             paddingTrailing: 0,
                                             width: 0,
                                             height: 0)
    }
    
    private func configureNavBar() {
        // OpenTable icon centered in navigation bar
        navigationItem.titleView = UIImageView(image: K.Images.openTable)
        navigationItem.titleView?.contentMode = .scaleAspectFit
    }
}

// MARK: - Timeline Detail View Controller Delegate

extension TimelineViewController: TransitionToTimelineDetailViewControllerDelegate {
    func presentDetailViewController(with detailedTimelineTweet: [TimelineTweet]) {
        let vc = TimelineDetailViewController()
        vc.timelineDetailTableView.detailedTimelineData = detailedTimelineTweet
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - User Profile View Controller Delegate

extension TimelineViewController: TransitionToUserProfileViewControllerDelegate {
    func presentUserProfileViewController(with username: String) {
        let vc = UserProfileViewController()
        vc.username = username
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Alert Delegate

extension TimelineViewController: AlertDelegate {
    func showAlert(with userToBlock: String) {
        Alert.showBlockAlert(title: "Block \(userToBlock)",
                             message: "\(userToBlock) will no longer be able to follow or reply to you, you will not see activity from this user.",
                             vc: self)
    }
}
