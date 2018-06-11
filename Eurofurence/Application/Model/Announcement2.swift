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
