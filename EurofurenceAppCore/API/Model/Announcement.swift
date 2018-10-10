//
//  Announcement.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct Announcement: Equatable {

    public struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        public typealias RawValue = String

        public init(_ value: String) {
            self.rawValue = value
        }

        public init?(rawValue: String) {
            self.rawValue = rawValue
        }

        public var rawValue: String

        public static func < (lhs: Announcement.Identifier, rhs: Announcement.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    public var identifier: Identifier
    public var title: String
    public var content: String
    public var date: Date

    public init(identifier: Identifier, title: String, content: String, date: Date) {
        self.identifier = identifier
        self.title = title
        self.content = content
        self.date = date
    }

}

public extension Announcement {

    public static func fromServerModels(_ models: [APIAnnouncement]) -> [Announcement] {
        return models.map(Announcement.init)
    }

    public init(serverModel: APIAnnouncement) {
        identifier = Announcement.Identifier(serverModel.identifier)
        title = serverModel.title
        content = serverModel.content
        date = serverModel.lastChangedDateTime
    }

}
