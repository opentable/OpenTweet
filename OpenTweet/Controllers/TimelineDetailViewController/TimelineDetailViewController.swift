//
//  TimelineDetailViewController.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/16/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let timelineDetailTableView: TimelineDetailTableView = {
        let tv = TimelineDetailTableView()
        return tv
    }()
    
    // MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureViewComponents()
        configureTableView()
    }

    // MARK: - Helper Functions
    
    private func configureTableView() {
        timelineDetailTableView.transitionToUserProfileViewControllerDelegate = self
        
        view.addSubview(timelineDetailTableView)
        timelineDetailTableView.anchorWithConstant(top: view.safeAreaLayoutGuide.topAnchor,
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
    
    private func configureViewComponents() {
        view.backgroundColor = K.Colors.white
    }
    
    private func configureNavBar() {
        navigationItem.title = "OpenTweet"
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainRed()]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
    }
}

extension TimelineDetailViewController: TransitionToUserProfileViewControllerDelegate {
    func presentUserProfileViewController(with username: String) {
        let vc = UserProfileViewController()
        vc.username = username
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
