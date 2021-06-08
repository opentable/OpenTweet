//
//  UserProfileView.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/18/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class UserProfileView: UIView {
    
    // MARK: - Properties
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = K.Colors.mainAppColor
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    private func configureView() {
        backgroundColor = K.Colors.white
        
        addSubview(usernameLabel)
        usernameLabel.centerXY(inView: self)
    }
}
