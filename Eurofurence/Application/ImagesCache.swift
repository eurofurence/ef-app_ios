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

    // MARK: Initialization

    init(eventBus: EventBus, imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
        eventBus.subscribe(consumer: self)
    }

    // MARK: Functions

    func cachedImageData(for identifier: String) -> Data? {
        return imageRepository.loadImage(identifier: identifier)?.pngImageData
    }

    // MARK: EventConsumer

    func consume(event: ImageDownloadedEvent) {
        let entity = ImageEntity(identifier: event.identifier, pngImageData: event.pngImageData)
        imageRepository.save(entity)
    }

}
