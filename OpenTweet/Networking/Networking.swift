import Foundation
import Alamofire

class Networking {
    static let shared = Networking()
    private var utilityQueue = DispatchQueue.global(qos: .utility)
    
    // add async/await
    func retrieveTweets(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else { return }
        
        AF.request(url)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
            //            .responseDecodable(of: [String: AnyObject].self, queue: utilityQueue) { response in
            //                debugPrint(response)
            //            }
                .response { response in
                    switch response.result {
                    case .success(let data):
                        guard let foundData = data else { return }
                        
                        do {
                            if let json = try JSONSerialization.jsonObject(with: foundData, options: []) as? [String: Any] {
                                print(json)
                            }
                        } catch {
                            print("fail")
                        }
                    case .failure(let error):
                        print("fail")
                    }
                }
    }
}
