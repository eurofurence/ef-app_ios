//
//  CapturingImageRepository.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
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
    
    func stub(identifier: String) {
        let entity = ImageEntity(identifier: identifier, pngImageData: identifier.data(using: .utf8)!)
        save(entity)
    }
    
    func stub(identifiers: [String]) {
        identifiers.forEach(stub)
    }
    
    func stubEverything(_ response: APISyncResponse) {
        response.images.changed.map({ $0.identifier }).forEach(stub)
    }
    
}
