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
        return images.first(where: { $0.identifier == identifier })?.pngImageData
    }

    func save() {
        images.forEach(imageRepository.save)
    }

    // MARK: EventConsumer

    func consume(event: ImageDownloadedEvent) {
        let entity = ImageEntity(identifier: event.identifier, pngImageData: event.pngImageData)
        images.append(entity)
    }

}
