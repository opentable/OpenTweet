//
//  AppCoordinator.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator {
  var navigationController: UINavigationController
  
  private let timelineService: TimelineService
  
  init(navigationController: UINavigationController, timelineService: TimelineService) {
    self.navigationController = navigationController
    self.timelineService = timelineService
  }
  
  func start() {
    let viewModel = TimelineViewModel(timelineService: timelineService)
    let viewController = TimelineViewController(viewModel: viewModel)
    viewModel.coordinator = self
    navigationController.pushViewController(viewController, animated: false)
  }
  
  func navigateToThread(thread: [Tweet]) {
    let threadViewModel = ThreadViewModel(thread: thread)
    let threadViewController = ThreadViewController(viewModel: threadViewModel)
    navigationController.pushViewController(threadViewController, animated: true)
  }
}
