//
//  ContextMenu.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/17/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol ContextMenu {
    //
}

extension ContextMenu {
    func configureDefaultContextMenu(blockAuthor: String) -> UIMenu {
        
        let likeAction = UIAction(title: "Like", image: K.Icons.like) { _ in
            print("I like this post.")
        }
        
        let followAction = UIAction(title: "Follow", image: K.Icons.follow) { _ in
            print("I want to follow this post.")
        }
        
        let saveFavoritesAction = UIAction(title: "Save to Favorites", image: K.Icons.saveFavorites) { _ in
            print("I saved this post.")
        }
        
        let blockAction = UIAction(title: "Block \(blockAuthor)", image: K.Icons.block) { _ in
            print("I want to block \(blockAuthor)")
            //                self?.alertDelegate?.showAlert(with: author ?? "User")
        }
        
        let reportAction  = UIAction(title: "Report this post", image: K.Icons.report) { _ in
            print("I want to report this.")
        }
        
        let menu = UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: [],
                          children: [likeAction, followAction, saveFavoritesAction, blockAction, reportAction])
        
        return menu
    }
}
