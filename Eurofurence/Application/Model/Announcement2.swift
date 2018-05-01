//
//  Announcement2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct Announcement2: Equatable {

    var title: String
    var content: String

    static func ==(lhs: Announcement2, rhs: Announcement2) -> Bool {
        return lhs.title == rhs.title && lhs.content == rhs.content
    }

}

extension Announcement2 {

    static func fromServerModels(_ models: [APIAnnouncement]) -> [Announcement2] {
        return models.map(Announcement2.init)
    }

    init(serverModel: APIAnnouncement) {
        title = serverModel.title
        content = serverModel.content
    }

}
