//
//  MainCoordinator.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        let tweetFeedCoordinator = TweetFeedCoordinator(navigationController: navigationController)
        tweetFeedCoordinator.start()
        childCoordinators.append(tweetFeedCoordinator)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
    }
}
