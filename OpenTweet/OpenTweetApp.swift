//
//  OpenTweetApp.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

@main
struct OpenTweetApp: App {

    var body: some Scene {
        let dataRepository = TweetDataRepository(dataService: TweetDataService())
        WindowGroup {
            ContentView().environmentObject(dataRepository)
        }
    }
}
