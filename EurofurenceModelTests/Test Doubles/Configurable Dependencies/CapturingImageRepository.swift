//
//  CapturingImageRepository.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingImageRepository: ImageRepository {

    fileprivate var savedImages = [ImageEntity]()
    func save(_ image: ImageEntity) {
        savedImages.append(image)
    }

    private(set) var deletedImages = [String]()
    func deleteEntity(identifier: String) {
        deletedImages.append(identifier)

        if let idx = savedImages.index(where: { $0.identifier == identifier }) {
            savedImages.remove(at: idx)
        }
    }

    func loadImage(identifier: String) -> ImageEntity? {
        return savedImages.first { $0.identifier == identifier }
    }

    func containsImage(identifier: String) -> Bool {
        return savedImages.contains(where: { $0.identifier == identifier })
    }

}

extension CapturingImageRepository {

    func didSave(_ images: [ImageEntity]) -> Bool {
        return savedImages.contains(elementsFrom: images)
    }

}
