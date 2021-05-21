//
//  AppCoordinator.swift
//  OpenTweet
//
//  Created by Iryna Rivera on 5/19/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol AppCoordinatorProtocol {
    init(navController: UINavigationController)
}

class AppCoordinator: AppCoordinatorProtocol {
    let navController: UINavigationController
    
    required init(navController: UINavigationController) {
        self.navController = navController
        self.showInitialFlow()
    }
    
    private func showInitialFlow() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "Tweets Controller") as! TweetsController
        let presenter = TweetsPresenter(controller: controller)
        controller.presenter = presenter
        
        self.navController.viewControllers = [controller]
    }
}
