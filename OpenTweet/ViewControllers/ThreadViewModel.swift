//
//  ThreadViewModel.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

class ThreadViewModel: ObservableObject {
  enum State {
    case idle
    case loading
    case success(tweets: [Tweet])
    case error(Error)
  }
  
  @Published var state: State = .idle
  @Published var thread: [Tweet]
  
  init(thread: [Tweet]) {
    self.thread = thread
  }
  
  func fetchThread() {
    state = .success(tweets: thread)
  }
}
