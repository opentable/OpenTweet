import SwiftUI

struct ContentView: View {
    let networkingText = Networking()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            networkingText.retrieveTweets(fileName: "timeline")
        }
    }
}
