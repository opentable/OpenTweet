//
//  AppDelegate.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
    var coordinator: AppCoordinatorProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navController = UINavigationController()
        window = UIWindow()
        coordinator = AppCoordinator(navController: navController)
       
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
		
        return true
	}
}

