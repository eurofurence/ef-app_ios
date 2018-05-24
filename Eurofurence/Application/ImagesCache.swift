//
//  ImagesCache.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class ImagesCache {

    private let imageRepository: ImageRepository
    private var images = [ImageEntity]()

    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }

    subscript(identifier: String) -> Data? {
        get {
            return images.first(where: { $0.identifier == identifier })?.pngImageData
        }
        set {
            if let data = newValue {
                images.append(ImageEntity(identifier: identifier, pngImageData: data))
            }
        }
    }

    func save() {
        images.forEach(imageRepository.save)
    }

}
