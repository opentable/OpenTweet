//
//  UIImageView+Extensions.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
  func loadImage(from url: URL, hitCache: Bool = true) {
    self.image = nil
    
    if hitCache, let cachedImage = imageCache.object(forKey: url.absoluteString as NSString)  {
      self.image = cachedImage
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
      else { return }
      DispatchQueue.main.async() { [weak self] in
        imageCache.setObject(image, forKey: url.absoluteString as NSString)
        self?.image = image
      }
    }.resume()
  }
}
