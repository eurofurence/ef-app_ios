//
//  AnnouncementImpl.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

struct AnnouncementImpl: Announcement {
    
    private let dataStore: DataStore
    private let imageRepository: ImageRepository
    private let characteristics: AnnouncementCharacteristics

    var identifier: AnnouncementIdentifier
    var title: String
    var content: String
    var date: Date

    init(dataStore: DataStore,
         imageRepository: ImageRepository,
         characteristics: AnnouncementCharacteristics) {
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        self.characteristics = characteristics
        
        self.identifier = AnnouncementIdentifier(characteristics.identifier)
        self.title = characteristics.title
        self.content = characteristics.content
        self.date = characteristics.lastChangedDateTime
    }
    
    func fetchAnnouncementImagePNGData(completionHandler: @escaping (Data?) -> Void) {
        var imageData: Data?
        if let imageIdentifier = characteristics.imageIdentifier {
            imageData = imageRepository.loadImage(identifier: imageIdentifier)?.pngImageData
        }
        
        completionHandler(imageData)
    }

}
