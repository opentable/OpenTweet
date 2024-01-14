//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by Dante Li on 2024-01-14.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Combine
import Foundation

protocol TimelineViewModel {
    var tweetsPublisher: AnyPublisher<[Tweet], Never> { get }
    func fetchData()
}

final class TimelineViewModelImpl: TimelineViewModel {
    
    lazy var tweetsPublisher: AnyPublisher<[Tweet], Never> = $tweets.eraseToAnyPublisher()
    @Published private var tweets: [Tweet] = []
    
    func fetchData() {
        guard let filePath = Bundle.main.url(forResource: "timeline", withExtension: "json") else {
            fatalError("Couldn't find the directory that has the data file!")
        }
        
        do {
            let data = try Data(contentsOf: filePath)
            let decoded = try JSONDecoder().decode(Timeline.self, from: data)
            tweets = decoded.timeline
            
            //print("Decoded the data: \(tweets)")
        } catch {
            print("Error decoding the data: \(error)")
        }
    }
}
