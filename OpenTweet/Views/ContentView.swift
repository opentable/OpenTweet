import SwiftUI

/// Define constants used at the top level of the app's view.
private enum AppConstants {
    struct AppText {
        static let title = "OpenTweet"
    }
    
    struct MainListSize {
        static let percentWidth = 0.8
    }
}

/// Top-level view from which all data is passed down view heirarchy. 
struct ContentView: View {
    @ObservedObject var dataProvider: TweetsDataProvider
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(dataProvider.tweets, id: \.id) { tweet in
                        TweetView(tweet: tweet)
                    }
                    .listRowSeparator(.hidden)
                    .listStyle(.plain)
                }
            }
            .task {
                await dataProvider.updateTweets()
            }
            .navigationTitle(AppConstants.AppText.title)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
