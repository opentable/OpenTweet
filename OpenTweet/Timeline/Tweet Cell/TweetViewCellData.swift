//
//  TweetViewCellData.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

class TweetViewCellData {
    var author: String
    var content: String
    var date: Date
    var avatar: String?
    var avatarImage: UIImage?

    init(author: String, content: String, date: Date, avatar: String?) {
        self.author = author
        self.content = content
        self.date = date
        self.avatar = avatar
    }

    func loadAvatarImage(_ reloader: ImageReloader) {
        guard avatarImage == nil else { return }
        guard let avatar else { return }
        guard let url = URL(string: avatar) else { return }
        downloadImage(reloader, url)
    }

    private func downloadImage(_ reloader: ImageReloader, _ url: URL) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard let data else { return }
            if let image = UIImage(data: data) {
                self.avatarImage = image
                reloader.update(with: image)
            }
        }.resume()
    }
}
