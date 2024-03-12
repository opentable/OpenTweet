import Foundation
import Alamofire

class Networking {
    static let shared = Networking()
    private var utilityQueue = DispatchQueue.global(qos: .utility)
    private var customDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ'"

        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        
        return jsonDecoder
    }
    
    // add async/await
    // error handling
    func retrieveTweets(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else { return }
        
        AF.request(url)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: ResponseData.self, queue: utilityQueue, decoder: customDecoder) { response in
                    debugPrint(response)
                }
    }
}
