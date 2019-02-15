//
//  Announcement.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public typealias AnnouncementIdentifier = Identifier<Announcement>

public protocol Announcement {

    var identifier: AnnouncementIdentifier { get }
    var title: String { get }
    var content: String { get }
    var date: Date { get }

}

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
