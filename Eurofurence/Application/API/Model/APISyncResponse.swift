//
//  APISyncResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APISyncDelta<T>: Equatable where T: Equatable {

    var changed: [T]
    var deleted: [T]

    init(changed: [T] = [], deleted: [T] = []) {
        self.changed = changed
        self.deleted = deleted
    }

    static func ==(lhs: APISyncDelta<T>, rhs: APISyncDelta<T>) -> Bool {
        return lhs.changed == rhs.changed && lhs.deleted == rhs.deleted
    }

}

struct APISyncResponse: Equatable {

    var knowledgeGroups: APISyncDelta<APIKnowledgeGroup>
    var knowledgeEntries: APISyncDelta<APIKnowledgeEntry>
    var announcements: APISyncDelta<APIAnnouncement>
    var events: APISyncDelta<APIEvent>
    var rooms: APISyncDelta<APIRoom>

    static func ==(lhs: APISyncResponse, rhs: APISyncResponse) -> Bool {
        return lhs.knowledgeGroups == rhs.knowledgeGroups &&
               lhs.knowledgeEntries == rhs.knowledgeEntries &&
               lhs.announcements == rhs.announcements &&
               lhs.events == rhs.events &&
               lhs.rooms == rhs.rooms
    }

}
