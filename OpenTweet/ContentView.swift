//
//  ContentView.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var dataRepository: TweetDataRepository

    var body: some View {
        switch dataRepository.data {
        case .error:
            Text("Error")
        case .loading:
            ProgressView()
        case .loaded(let tweets):
            List(tweets, id: \.id) { tweet in
                VStack(alignment: .leading) {
                    Text(tweet.author).font(.title2)
                    Text(tweet.content).font(.body)
                }
            }.listStyle(.plain)
        }
    }
}

#Preview {
    ContentView().environmentObject(TweetDataRepository(dataService: TweetDataService()))
}
