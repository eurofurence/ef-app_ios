//
//  AnnouncementImpl.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

struct AnnouncementImpl: Announcement {

    var identifier: AnnouncementIdentifier
    var title: String
    var content: String
    var date: Date

    init(identifier: AnnouncementIdentifier, title: String, content: String, date: Date) {
        self.identifier = identifier
        self.title = title
        self.content = content
        self.date = date
    }

}

extension AnnouncementImpl {

    static func fromServerModels(_ models: [AnnouncementCharacteristics]) -> [AnnouncementImpl] {
        return models.map(AnnouncementImpl.init)
    }

    init(serverModel: AnnouncementCharacteristics) {
        identifier = AnnouncementIdentifier(serverModel.identifier)
        title = serverModel.title
        content = serverModel.content
        date = serverModel.lastChangedDateTime
    }

}
