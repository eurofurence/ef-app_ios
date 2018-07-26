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
    var deleted: [String]

    init(changed: [T] = [], deleted: [String] = []) {
        self.changed = changed
        self.deleted = deleted
    }

}

struct APISyncResponse: Equatable {

    var knowledgeGroups: APISyncDelta<APIKnowledgeGroup>
    var knowledgeEntries: APISyncDelta<APIKnowledgeEntry>
    var announcements: APISyncDelta<APIAnnouncement>
    var events: APISyncDelta<APIEvent>
    var rooms: APISyncDelta<APIRoom>
    var tracks: APISyncDelta<APITrack>
    var conferenceDays: APISyncDelta<APIConferenceDay>
    var dealers: APISyncDelta<APIDealer>
    var maps: APISyncDelta<APIMap>

}
