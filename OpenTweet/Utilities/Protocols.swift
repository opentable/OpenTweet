//
//  Protocols.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/16/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

protocol TransitionToTimelineDetailViewControllerDelegate: AnyObject {
    func presentDetailViewController(with detailedTimelineTweet: [TimelineTweet])
}

protocol TransitionToUserProfileViewControllerDelegate: AnyObject {
    func presentUserProfileViewController(with username: String)
}

protocol AlertDelegate: AnyObject {
    func showAlert(with userToBlock: String)
}
