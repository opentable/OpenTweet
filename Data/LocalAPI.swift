import Foundation

func inject() -> API {
    return LocalAPI()
}

class LocalAPI: API {
    enum Error: Swift.Error {
        case missingResource
    }

    func fetchTimeline(completion: @escaping (Result<Timeline, Swift.Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            do {
                guard let url = Bundle(for: LocalAPI.self)
                    .url(forResource: "timeline", withExtension: "json")
                else { throw Error.missingResource }

                let data = try Data(contentsOf: url)
                var result = try JSONDecoder().decode(Timeline.self, from: data)
                result.timeline = result.timeline.sortedByDate()
                completion(.success(result))
            } catch {
                completion(.failure(error))
                return
            }
        }
    }
}
