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

    var identifier: AnnouncementIdentifier
    var title: String
    var content: String
    var date: Date

    init(dataStore: DataStore,
         imageRepository: ImageRepository,
         identifier: AnnouncementIdentifier,
         title: String,
         content: String,
         date: Date) {
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        
        self.identifier = identifier
        self.title = title
        self.content = content
        self.date = date
    }
    
    func fetchAnnouncementImagePNGData(completionHandler: @escaping (Data?) -> Void) {
        let announcement = dataStore.fetchAnnouncements()?.first(where: { $0.identifier == identifier.rawValue })
        let imageData: Data? = announcement.let { (announcement) in
            let entity: ImageEntity? = announcement.imageIdentifier.let(imageRepository.loadImage)
            return entity?.pngImageData
        }
        
        completionHandler(imageData)
    }

}
