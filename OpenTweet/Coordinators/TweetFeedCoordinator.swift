//
//  TweetFeedCoordinator.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

public final class TweetFeedCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        routeToTimeline()
    }
    
    private func routeToTimeline() {
        let timelineViewModel = TimelineViewModel(
            timelineService: TimelineService()) { [weak self] tweet in
                self?.routeToTweetThread(tweet: tweet)
            }
        let timelineViewController = TimelineViewController(viewModel: timelineViewModel)
        
        navigationController.pushViewController(timelineViewController, animated: true)
    }
    
    private func routeToTweetThread(tweet: Tweet) {
        let threadViewModel = ThreadViewModel(tweet: tweet)
        let threadViewController = ThreadViewController(viewModel: threadViewModel)
        
        navigationController.pushViewController(threadViewController, animated: true)
    }
}
