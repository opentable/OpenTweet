import SwiftUI

private enum AppConstants {
    struct AppText {
        static let title = "OpenTweet"
    }
    
    struct MainListSize {
        static let percentWidth = 0.8
    }
}

struct ContentView: View {
    // MARK: State, Binding, Environment properties
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
