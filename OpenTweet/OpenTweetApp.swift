//
//  OpenTweetApp.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

@main
struct OpenTweetApp: App {
    let dataRepository = TweetDataRepository(dataService: TweetDataService())

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(dataRepository)
        }
    }
}
