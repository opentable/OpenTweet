//
//  ImageService.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

class ImageService {
    static let shared = ImageService()
    typealias ImageClosure = (UIImage?) -> Void
    private let operationQueue = OperationQueue()
    private var activeDownloads: [URL: BlockOperation] = [:]
    private var waitingOperations: [URL: [ImageClosure]] = [:]
    private var cachedImages = NSCache<NSString, UIImage>()

    private init() {
        cachedImages.countLimit = 10
    }

    func saveImage(image: UIImage, url: URL) {
        DispatchQueue.global(qos: .background).async {
            guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
                return
            }
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return
            }
            do {
                try data.write(to: directory.appendingPathComponent(url.lastPathComponent)!)
                print("saved image to cache")
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func getImageFromCache(url: URL, completion: @escaping ImageClosure) {
        print("getting image from cache \(url)")
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let data = try Data(contentsOf: directory.appendingPathComponent(url.lastPathComponent))
                let image = UIImage(data: data)
                self?.releaseImages(url: url, image: image)
                if let image = image {
                    DispatchQueue.main.async { [weak self] in
                         let urlString = NSString(string: url.absoluteString)

                        self?.cachedImages.setObject(image, forKey: urlString)
                    }
                }
                completion(image)
            } catch {
                completion(nil)
            }
        }
    }

    func downloadImage(url: URL, completion: @escaping ImageClosure) {
        print("downloading image \(url)")
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            if let image = image {
                saveImage(image: image, url: url)
            }
            releaseImages(url: url, image: image)
            completion(image)
        } catch {
            completion(nil)
        }
    }

    private func releaseImages(url: URL, image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            print("releasing \((self?.waitingOperations[url] ?? []).count) images in queue for \(url)")
            self?.waitingOperations[url]?.forEach { $0(image) }
            self?.waitingOperations[url]?.removeAll()
            self?.activeDownloads.removeValue(forKey: url)
        }
    }

    func getImage(url: URL) async throws -> UIImage? {
        if let image = cachedImages.object(forKey: NSString(string: url.absoluteString)) {
            return image
        }
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async { [weak self] in
                do {
                    try self?.getImage(url: url) { image in
                        continuation.resume(returning: image)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getImage(url: URL, completion: @escaping ImageClosure) throws {
        if let _ = activeDownloads[url] {
            if waitingOperations[url] != nil {
                waitingOperations[url]?.append(completion)
            } else {
                waitingOperations[url] = [completion]
            }
        } else {
            let downloadOperation = BlockOperation {
                self.getImageFromCache(url: url) { image in
                    guard let image = image else {
                        self.downloadImage(url: url, completion: completion)
                        return
                    }
                    completion(image)
                }
            }
            if activeDownloads[url] == nil {
                activeDownloads[url] = downloadOperation
                operationQueue.addOperation(downloadOperation)
            }
        }
    }
}
