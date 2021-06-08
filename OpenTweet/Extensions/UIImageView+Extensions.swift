//
//  UIImageView+Extensions.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/16/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

// MARK: - Function to get image from URL

extension UIImageView {
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error when loading image data")
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.image = image
            }
        }.resume()
    }
    
    func configureAvatarImageView() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = K.Colors.white
        iv.layer.borderWidth = 1
        iv.layer.borderColor = K.Colors.mainAppColor.cgColor
        iv.clipsToBounds = true
        return iv
    }
}
