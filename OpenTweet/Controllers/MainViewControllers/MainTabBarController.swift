//
//  MainTabBarController.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/15/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit
import Combine

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    private var timelineVC = TimelineViewController()
    private var searchVC = SearchViewController()
    private var ordersVC = OrderViewController()
    private var profileVC = ProfileViewController()
    
    var subscriber: AnyCancellable?
    
    // MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        
        let timelineController = configureNavControllers(vc: timelineVC,
                                                         title: K.Navigation.timeline,
                                                         image: K.Icons.timeline)
        let searchController = configureNavControllers(vc: searchVC,
                                                       title: K.Navigation.search,
                                                       image: K.Icons.search)
        let ordersController = configureNavControllers(vc: ordersVC,
                                                       title: K.Navigation.order,
                                                       image: K.Icons.order)
        let profileController = configureNavControllers(vc: profileVC,
                                                        title: K.Navigation.profile,
                                                        image: K.Icons.profile)
        
        viewControllers = [timelineController, searchController, ordersController, profileController]
    }
    
    override func loadView() {
        super.loadView()
        fetchJSONData()
    }
    
    // MARK: - Helper Functions
    
    private func configureTabBar() {
        // Set delegate to self in order to get tab bar tap actions
        delegate = self
        tabBar.tintColor = K.Colors.mainAppColor
        tabBar.barTintColor = K.Colors.white
        tabBar.backgroundColor = K.Colors.white
        tabBar.isTranslucent = false
        
        // Remove default top border line from tab bar
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        // Implement my own top border line to circumvent dark mode issues
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: K.Layout.screenWidth, height: 1))
        topLine.backgroundColor = K.Colors.lightGray
        tabBar.addSubview(topLine)
    }
    
    // Configuration for all four view controllers in the tab bar
    private func configureNavControllers(vc: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.tintColor = K.Colors.mainAppColor
        navController.navigationBar.barTintColor = K.Colors.white
        navController.navigationBar.isTranslucent = false
        
        // Remove default bottom border line from navigation bar
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        return navController
    }
}

// MARK: - Tapping Timeline Tab Bar Button Again

extension MainTabBarController {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Get view controllers
        guard let viewControllers = viewControllers else { return false }
        // If view controller of tapped tab bar button matches current view controller, it's a second tap
        if viewController == viewControllers[selectedIndex] {
            // Get navigation controller and the first view controller in the stack
            if let navVC = viewController as? UINavigationController,
               let vc = navVC.viewControllers.first as? TimelineViewController {
                // If the first view controller is currently visible, scroll to top of table view
                if vc.isViewLoaded && vc.view.window != nil {
                    timelineVC.timelineTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
        return true
    }
}

// MARK: - JSON Data Fetch

extension MainTabBarController {
    func fetchJSONData() {
        guard let jsonPath = Bundle.main.path(forResource: K.JSON.timeline, ofType: K.JSON.json) else {
            Alert.showDefaultAlert(title: K.Alert.errorTitle, message: K.Alert.invalidPathMessage, vc: self)
            return
        }
        
        let jsonURL = URL(fileURLWithPath: jsonPath)
        
        self.subscriber = NetworkManager.shared.fetchTimeline(from: jsonURL)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished!")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] timelineDataValues in
                self?.timelineVC.timelineTableView.timelineData = timelineDataValues
            })
        
//        NetworkManager.shared.fetchTimelineTweets(from: jsonURL) { [weak self] result in
//            guard let strongSelf = self else { return }
//
//            switch result {
//            case .success(let success):
//                self?.timelineVC.timelineTableView.timelineData = success
//            case .failure(let error):
//                Alert.showDefaultAlert(title: K.Alert.errorTitle,
//                                       message: error.localizedDescription,
//                                       vc: strongSelf)
//            }
//        }
    }
}
