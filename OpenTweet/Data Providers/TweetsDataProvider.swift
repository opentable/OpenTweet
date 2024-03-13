import Foundation
import SwiftUI
import Alamofire

class TweetsDataProvider: ObservableObject {
    let sharedNetworking = Networking()
    @Published var tweets = [Tweet]()
    @Published var errorMessage: String?
    
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
