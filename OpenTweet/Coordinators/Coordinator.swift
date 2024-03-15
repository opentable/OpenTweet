//
//  Coordinator.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-11.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
