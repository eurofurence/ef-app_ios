//
//  MapImpl.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

struct MapImpl: Map {
    
    private let imageRepository: ImageRepository
    private let characteristics: MapCharacteristics

    var identifier: MapIdentifier
    var location: String

    init(imageRepository: ImageRepository, characteristics: MapCharacteristics) {
        self.imageRepository = imageRepository
        self.characteristics = characteristics
        
        self.identifier = MapIdentifier(characteristics.identifier)
        self.location = characteristics.mapDescription
    }
    
    func fetchImagePNGData(completionHandler: @escaping (Data) -> Void) {
        if let image = imageRepository.loadImage(identifier: characteristics.imageIdentifier) {
            completionHandler(image.pngImageData)
        }
    }

}
