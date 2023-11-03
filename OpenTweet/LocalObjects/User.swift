//
//  User.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-03.
//

import Foundation

struct User: Hashable {
    let id, author: String
    let avatar: String?
}

extension Tweet {
    func toUser() -> User {
        return User(id: id, author: author, avatar: avatar)
    }
}
