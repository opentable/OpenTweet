import Foundation

let api = inject()

protocol API {
    func fetchTimeline(completion: @escaping (Result<Timeline, Swift.Error>) -> Void)
}
