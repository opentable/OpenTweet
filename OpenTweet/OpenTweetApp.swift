import SwiftUI

@main
struct OpenTweetApp: App {
    let tweetsDataProvider = TweetsDataProvider()
    
    var body: some Scene {
        WindowGroup {
            ContentView(dataProvider: tweetsDataProvider)
        }
    }
}
