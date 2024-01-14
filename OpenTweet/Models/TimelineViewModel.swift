//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by Dante Li on 2024-01-14.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

protocol TimelineViewModel {
    func fetchData()
    
    var tweets: [Tweet] { get }
}

final class TimelineViewModelImpl: TimelineViewModel {
    
    private(set) var tweets: [Tweet] = []
    
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
