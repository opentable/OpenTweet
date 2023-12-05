import UIKit

/// Provides utility method to download an image from a URL and store it in the local directory for future
protocol ImageProvidable {}

extension ImageProvidable {
    func fetchImage(fromUrl url: URL, completion: @escaping (UIImage?) -> Void) {
        let fileManager = FileManager.default
        
        /// `cachesDirectory` is used so that the unused images get deleted when system runs out of memory
        /// It can be easily replaced with `documentDirectory` if the images have to be persisted forever,
        /// which is not recommended unless a mechanism to delete photos is developed based on requirement
        guard let cachesDirectoryUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            completion(nil)
            return
        }
        
        let fileUrl = cachesDirectoryUrl.appendingPathComponent(url.lastPathComponent)
        
        if fileManager.fileExists(atPath: fileUrl.path),
           let imageData = try? Data(contentsOf: fileUrl) {
            completion(UIImage(data: imageData))
        } else {
            URLSession.shared.dataTask(with: url) { (imageData, _, _) in
                guard let imageData else {
                    completion(nil)
                    return
                }
                try? imageData.write(to: fileUrl, options: .atomic)
                completion(UIImage(data: imageData))
            }.resume()
        }
    }
}
