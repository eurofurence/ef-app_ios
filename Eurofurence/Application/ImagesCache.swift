//
//  ImagesCache.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class ImagesCache: EventConsumer {

    // MARK: Properties

    private let imageRepository: ImageRepository
    private var images = [ImageEntity]()

    // MARK: Initialization

    init(eventBus: EventBus, imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
        eventBus.subscribe(consumer: self)
    }

    // MARK: Functions

    func cachedImageData(for identifier: String) -> Data? {
        let inMemoryCacheHit = images.first(where: { $0.identifier == identifier })?.pngImageData
        if let hit = inMemoryCacheHit {
            return hit
        } else {
            return imageRepository.loadImage(identifier: identifier)?.pngImageData
        }
    }

    // MARK: EventConsumer

    func consume(event: ImageDownloadedEvent) {
        let entity = ImageEntity(identifier: event.identifier, pngImageData: event.pngImageData)
        images.append(entity)
        imageRepository.save(entity)
    }

}
