//
//  TweetsPresenter.swift
//  OpenTweet
//
//  Created by Iryna Rivera on 5/19/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol TweetsPresenterProtocol: class {
    func loadInitialData()
}

class TweetsPresenter: TweetsPresenterProtocol {
    private weak var controller: TweetsControllerProtocol?
    private var tweets = [TweetInfo]()
    
    init(controller: TweetsControllerProtocol) {
        self.controller = controller
    }
    
    func loadInitialData() {
        let url = Bundle.main.url(forResource: "timeline", withExtension: "json")!
        do {
          let data = try Data(contentsOf: url)
          let json = try JSONDecoder().decode(Timeline.self, from: data)
            tweets = json.timeline
            controller?.show(tweets)
        }
        catch {
          print("Error occured during Parsing", error)
        }
    }
}


