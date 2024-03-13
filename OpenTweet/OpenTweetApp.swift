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

/**
 1. Highlight mentions and links
 2. Allow clicks to replies on main comment, reply that has a comment.
 3. Add comments to code - check soapbox comments.
 */
