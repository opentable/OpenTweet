import Foundation
import Alamofire

class Networking {
    static let shared = Networking()
    private var customDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ'"

        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        
        return jsonDecoder
    }
    
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
