//
//  PersistentImageRepository.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct PersistentImageRepository: ImageRepository {

    func save(_ image: ImageEntity) {
        do {
            let imageURL = try makeImageRepositoryURL(for: image.identifier)
            try image.pngImageData.write(to: imageURL)
        } catch {
            print(error)
        }
    }

    func loadImage(identifier: String) -> ImageEntity? {
        do {
            let imageURL = try makeImageRepositoryURL(for: identifier)
            let imageData = try Data(contentsOf: imageURL)
            return ImageEntity(identifier: identifier, pngImageData: imageData)
        } catch {
            print(error)
            return nil
        }
    }

    private func makeImageRepositoryURL(for identifier: String) throws -> URL {
        let applicationSupportDirectoryURL = try FileManager.default.url(for: .applicationSupportDirectory,
                                                                         in: .userDomainMask,
                                                                         appropriateFor: nil,
                                                                         create: false)
        let cacheDirectoryURL = applicationSupportDirectoryURL.appendingPathComponent("EFImageCache")

        if FileManager.default.fileExists(atPath: cacheDirectoryURL.path, isDirectory: nil) == false {
            try FileManager.default.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: false)
        }

        return cacheDirectoryURL.appendingPathComponent(identifier)
    }

}
