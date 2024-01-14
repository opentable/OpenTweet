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
    func retrieveAvatar(in tweet: Tweet) async -> Data?
}

final class TimelineViewModelImpl: TimelineViewModel {
    
    lazy var tweetsPublisher: AnyPublisher<[Tweet], Never> = $tweets.eraseToAnyPublisher()
    @Published private var tweets: [Tweet] = []
    
    private lazy var networks = Networks()
    
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
    
    func retrieveAvatar(in tweet: Tweet) async -> Data? {
        guard let avatarLink = tweet.avatarLink else { return nil }
        
        if let url = URL(string: avatarLink) {
            let data = await networks.download(url: url)
            
            tweet.avatarData = data
            return data
        }
        
        return nil
    }
}
