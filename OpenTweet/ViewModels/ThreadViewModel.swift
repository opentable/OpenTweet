//
//  ThreadViewModel.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

protocol ThreadViewModelInterface {
    var tweet: Tweet { get }
}

final class ThreadViewModel: ThreadViewModelInterface {
    let tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
}
