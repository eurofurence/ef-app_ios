//
//  Announcement.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public typealias AnnouncementIdentifier = Identifier<Announcement>

public protocol AnnouncementProtocol {

    var identifier: AnnouncementIdentifier { get }
    var title: String { get }
    var content: String { get }
    var date: Date { get }

}

public struct Announcement: AnnouncementProtocol {

    public var identifier: AnnouncementIdentifier
    public var title: String
    public var content: String
    public var date: Date

    public init(identifier: AnnouncementIdentifier, title: String, content: String, date: Date) {
        self.identifier = identifier
        self.title = title
        self.content = content
        self.date = date
    }

}

extension Announcement {

    static func fromServerModels(_ models: [AnnouncementCharacteristics]) -> [Announcement] {
        return models.map(Announcement.init)
    }

    init(serverModel: AnnouncementCharacteristics) {
        identifier = AnnouncementIdentifier(serverModel.identifier)
        title = serverModel.title
        content = serverModel.content
        date = serverModel.lastChangedDateTime
    }

}
