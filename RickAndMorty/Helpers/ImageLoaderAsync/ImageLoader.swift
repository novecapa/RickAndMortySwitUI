//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import SwiftUI

let imageCache: NSCache<AnyObject, AnyObject> = NSCache<AnyObject, AnyObject>()

@Observable
class ImageLoader {

    private enum Constants {
        static let maxMB: Int = 50 * 1024 * 1024
        static let maxImages: Int = 512
    }

    var fileId: String?
    var image: UIImage?
    var imageURL: URL?

    init() {
        // imageCache.totalCostLimit = Constants.maxMB
        // imageCache.countLimit = Constants.maxImages
    }

    private var cacheDirectoryPath: URL? {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths.first
    }

    private func localFilePath(for url: URL) -> URL? {
        var fileName = url.lastPathComponent
        if !fileName.contains(".") {
            if let fileId {
                fileName = fileId + ".png"
            } else {
                fileName = UUID().uuidString + ".png"
            }
        }
        return cacheDirectoryPath?.appendingPathComponent(fileName)
    }

    func loadImage(with url: URL) {
        imageURL = url
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }

        if let localPath = localFilePath(for: url),
           let data = try? Data(contentsOf: localPath),
           let cachedImage = UIImage(data: data) {
            self.image = cachedImage
            imageCache.setObject(cachedImage, forKey: url as AnyObject)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let downloadedImage = UIImage(data: data),
                  self.imageURL == url else {
                return
            }
            Task { @MainActor in
                imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                self.image = downloadedImage
                if let localPath = self.localFilePath(for: url) {
                    try? data.write(to: localPath)
                }
            }
        }.resume()
    }
}
