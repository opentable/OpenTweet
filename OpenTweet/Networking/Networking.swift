import Foundation
import Alamofire

/// Main singleton for sharing network requests app-wide.
class Networking {
    static let shared = Networking()
    private var customDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ'"

        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        
        return jsonDecoder
    }
    /**
     Use Alamofire to serialize the tweet timeline from a local file asynchronously.
     
     - Parameters:
         - fileName: The JSON formatted list of tweets.
     - Used Alamofire instead of `JSONSerialization` because it closely resembles a real world network request. In a real application we would get our data from a remote server. Robustness and community support have made Alamofire a reliable, production ready networking client. Extending this request for a real world request only requires updating `url` to the endpoint `String`.
     - Returns: Result type with either the decoded model data or an error.
     */
    func retrieveTweets(fileName: String) async -> Result<ResponseData, AFError> {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return .failure(.responseSerializationFailed(reason: .inputFileNil))
        }
        
        let dataTask = AF.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .serializingDecodable(ResponseData.self, decoder: customDecoder)
        let result = await dataTask.result
        
        return result
    }
}
