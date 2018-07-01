//
//  Announcement2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct Announcement2: Equatable {

    struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        typealias RawValue = String

        init(_ value: String) {
            self.rawValue = value
        }

        init?(rawValue: String) {
            self.rawValue = rawValue
        }

        var rawValue: String

        static func < (lhs: Announcement2.Identifier, rhs: Announcement2.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    var identifier: Identifier
    var title: String
    var content: String

}

extension Announcement2 {

    static func fromServerModels(_ models: [APIAnnouncement]) -> [Announcement2] {
        return models.map(Announcement2.init)
    }

    init(serverModel: APIAnnouncement) {
        identifier = Announcement2.Identifier(serverModel.identifier)
        title = serverModel.title
        content = serverModel.content
    }

}
