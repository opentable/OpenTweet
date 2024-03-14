import Foundation
import SwiftUI
import Alamofire

/// Provide the views with tweets
class TweetsDataProvider: ObservableObject {
    let sharedNetworking = Networking()
    @Published var tweets = [Tweet]()
    @Published var errorMessage: String?
    
    /**
     Asynchronously retrieve tweets and pass them along to view.
     
     - Fixme: errors are not handled yet.
     */
    func updateTweets() async {
        let result = await sharedNetworking.retrieveTweets(fileName: "timeline")
        
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                self.tweets = data.timeline
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
