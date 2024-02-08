import Foundation
import UIKit
import CoreImage

class AvatarService {
    enum Error: Swift.Error {
        case fetchError
        case imageProcessingError
        case badData
    }

    static let shared = AvatarService()

    var maxCacheEntries: Int = 100

    // Hack alert. Normally, I'd want to have the size of the avatar's on-screen
    // representation reachable somewhere from the code, i.e. in a constant
    // somewhere. That way we could calculate the size of the image we need
    // dynamicaly based on the pixel dimention of the device's screen we are
    // living on. However, we're using storyboards here, so this code has no
    // idea how big to make avatars. I've hard-coded values here, but it's a
    // vector for future bugs if we ever change the UI's layout.
    var avatarSize: CGSize = CGSize(width: 240, height: 240)

    // For resizing avatars to cache, etc
    private let context = CIContext()

    private var cache: Set<Avatar> = Set<Avatar>()

    private func addToCache(avatar: Avatar) throws {
        // Because of the custom hashable / equatable implementation below,
        // this *should* return any existing cache entries for the same
        // remote URL...
        if let cached = cache.remove(avatar) {
            let url = Self.localURL(avatar: cached)
            try FileManager.default.removeItem(at: url)
        }
        cache.insert(avatar)
    }

    // Trim cache for maxCacheEntries, removing the oldest entries
    private func cleanCache() {
        guard cache.count > maxCacheEntries else { return }

        let sortedItems = cache.sorted { $0.fetchDate < $1.fetchDate }
        let i = min(maxCacheEntries, sortedItems.endIndex) - 1
        let newItems = sortedItems.prefix(i)
        let staleItems = sortedItems.suffix(from: i)
        cache = Set(newItems)
        DispatchQueue.global().async {
            for avatar in staleItems {
                do {
                    let url = Self.localURL(avatar: avatar)
                    try FileManager.default.removeItem(at: url)
                } catch {
                    print(error)
                }
            }
        }
    }

    private static func localURL(avatar: Avatar) -> URL {
        let cacheFolder = try! FileManager.default
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil,
                 create: true).appendingPathComponent("avatars")
        try! FileManager.default.createDirectory(at: cacheFolder, withIntermediateDirectories: true)

        return cacheFolder.appendingPathComponent(avatar.userID)
    }

    private func cachedAvatar(remoteURL: URL) -> (Avatar, UIImage)? {
        guard let avatar = cache.filter ({ $0.remoteURL == remoteURL }).first
        else { return nil }

        let url = Self.localURL(avatar: avatar)
        do {
            let data = try Data(contentsOf: url)
            guard let image = UIImage(data: data)
            else { throw Error.badData }
            return (avatar, image)
        } catch {
            return nil
        }
    }

    func fetchAvatar(url: URL, userID: UserID, forceRefresh: Bool = false,
                     completion: @escaping (Result<UIImage, Swift.Error>) -> Void) {
        if !forceRefresh, let (_, image) = cachedAvatar(remoteURL: url) {
            completion(.success(image))
            return
        }
        let avatar = Avatar(userID: userID, remoteURL: url, fetchDate: Date())

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, resp, error in
            guard let self = self else { return }

            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = CIImage(data: data) {
                let colorSpace = image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!
                let resized = image.scaledToFill(self.avatarSize)
                    .croppedTo(size: self.avatarSize)
                do {
                    guard let jpeg = self.context.jpegRepresentation(of: resized, colorSpace: colorSpace)
                    else { throw Error.imageProcessingError }
                    try jpeg.write(to: Self.localURL(avatar: avatar))
                    let image = UIImage(ciImage: resized)
                    completion(.success(image))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

// Cache entry, more or less
fileprivate struct Avatar: Codable {
    var userID: UserID
    var remoteURL: URL
    var fetchDate: Date
}

// MARK: Equatable
/*
 For our purposes here, the contents don't matter - only whether this represents
 a unique remote URL
 */
extension Avatar: Equatable {
    static func ==(lhs: Avatar, rhs: Avatar) -> Bool {
        return lhs.remoteURL == rhs.remoteURL
    }
}

// MARK: Hashable
extension Avatar: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(remoteURL)
    }
}

// MARK: Util

fileprivate enum ScalingType {
    case fit
    case fill
}

// Here be dragons: in an image editing application, these extensions won't
// always do the right thing, but they should work for our use case here.
fileprivate extension CIImage {
    func applyScale(_ scale: CGFloat) -> CIImage {
        if scale == 1.0 { return self }
        return self
            .samplingLinear()
            .transformed(by: CGAffineTransform(scaleX: scale, y: scale))
    }

    func scaledToFill(_ size: CGSize) -> CIImage {
        var result = self
        let s = extent.size.scaleRatio(to: .fill, size: size)
        // Use nearest neighbor sampling for upscaling
        if s > 1 { result = result.samplingNearest() }
        return result.applyScale(s)
    }

    func withOriginAtZero() -> CIImage {
        let t = CGAffineTransform(translationX: -extent.origin.x,
                                  y: -extent.origin.y)
        return self.transformed(by: t)
    }

    func centeredOn(_ point: CGPoint) -> CIImage {
        let t = CGAffineTransform(translationX: point.x - extent.midX,
                                  y: point.y - extent.midY)
        return self.transformed(by: t)
    }

    // Center crop to the given size
    func croppedTo(size: CGSize) -> CIImage {
        let canvas = CGRect(origin: .zero, size: size)
            .centeredOn(self.extent.center)
        return self.cropped(to: canvas).withOriginAtZero()
    }
}

fileprivate extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    func centeredOn(_ point: CGPoint) -> CGRect {
        var result = self
        result.origin.x = point.x - self.width * 0.5
        result.origin.y = point.y - self.height * 0.5
        return result
    }
}

fileprivate extension CGSize {
    func scaleRatio(to fitType: ScalingType, size containerSize: CGSize) -> CGFloat {
        switch fitType {
        case .fit:
            return min(containerSize.width / width,
                       containerSize.height / height)
        case .fill:
            return max(containerSize.width / width,
                       containerSize.height / height)
        }
    }
}
