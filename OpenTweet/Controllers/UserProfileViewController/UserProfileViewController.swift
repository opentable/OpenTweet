//
//  UserProfileViewController.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/17/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var userProfileView: UserProfileView { return self.view as! UserProfileView }
    
    var username: String?
    
    // MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureViewComponents()
    }
    
    override func loadView() {
        self.view = UserProfileView(frame: UIScreen.main.bounds)
    }
    
    // MARK: - Helper Functions
    
    private func configureNavBar() {
        navigationItem.title = username
    }
    
    private func configureViewComponents() {
        if let username = username {
            userProfileView.usernameLabel.text = "\(username)'s profile"
        }
    }
}
