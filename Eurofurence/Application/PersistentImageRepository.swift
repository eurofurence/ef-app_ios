//
//  PersistentImageRepository.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct PersistentImageRepository: ImageRepository {

    public init() {
    }

    public func save(_ image: ImageEntity) {
        do {
            let imageURL = try makeImageRepositoryURL(for: image.identifier)
            try image.pngImageData.write(to: imageURL)
        } catch {
            print(error)
        }
    }

    public func deleteEntity(identifier: String) {
        do {
            let imageURL = try makeImageRepositoryURL(for: identifier)
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print(error)
        }
    }

    public func loadImage(identifier: String) -> ImageEntity? {
        do {
            let imageURL = try makeImageRepositoryURL(for: identifier)
            let imageData = try Data(contentsOf: imageURL)
            return ImageEntity(identifier: identifier, pngImageData: imageData)
        } catch {
            print(error)
            return nil
        }
    }

    public func containsImage(identifier: String) -> Bool {
        return loadImage(identifier: identifier) != nil
    }

    private func makeImageCacheDirectoryURL() throws -> URL {
        return FileUtilities.sharedContainerURL.appendingPathComponent("EFImageCache")
    }

    private func makeImageRepositoryURL(for identifier: String) throws -> URL {
        let cacheDirectoryURL = try makeImageCacheDirectoryURL()

        if FileManager.default.fileExists(atPath: cacheDirectoryURL.path, isDirectory: nil) == false {
            try FileManager.default.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: false)
        }

        return cacheDirectoryURL.appendingPathComponent(identifier)
    }

}
