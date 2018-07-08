//
//  ImageDownloader.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class ImageDownloader {

    private let eventBus: EventBus
    private let imageAPI: ImageAPI
    private let imageRepository: ImageRepository

    init(eventBus: EventBus, imageAPI: ImageAPI, imageRepository: ImageRepository) {
        self.eventBus = eventBus
        self.imageAPI = imageAPI
        self.imageRepository = imageRepository
    }

    func downloadImages(identifiers: [String], parentProgress: Progress, completionHandler: @escaping () -> Void) {
        guard !identifiers.isEmpty else {
            completionHandler()
            return
        }

        var pendingImageIdentifiers = identifiers
        let imagesToDownload = identifiers.filter({ imageRepository.containsImage(identifier: $0) == false })
        guard !imagesToDownload.isEmpty else {
            parentProgress.totalUnitCount = 1
            parentProgress.completedUnitCount = 1
            completionHandler()
            return
        }

        imagesToDownload.forEach { (identifier) in
            imageAPI.fetchImage(identifier: identifier) { (data) in
                guard let idx = pendingImageIdentifiers.index(of: identifier) else { return }
                pendingImageIdentifiers.remove(at: idx)

                var completedUnitCount = parentProgress.completedUnitCount
                completedUnitCount += 1
                parentProgress.completedUnitCount = completedUnitCount

                if let data = data {
                    let event = ImageDownloadedEvent(identifier: identifier, pngImageData: data)
                    self.eventBus.post(event)
                }

                if pendingImageIdentifiers.isEmpty {
                    completionHandler()
                }
            }
        }
    }

}
