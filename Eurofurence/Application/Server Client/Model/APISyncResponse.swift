//
//  APISyncResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct APISyncDelta<T>: Equatable where T: Equatable {

    public var changed: [T]
    public var deleted: [String]
    public var removeAllBeforeInsert: Bool

    public init(changed: [T] = [], deleted: [String] = [], removeAllBeforeInsert: Bool = false) {
        self.changed = changed
        self.deleted = deleted
        self.removeAllBeforeInsert = removeAllBeforeInsert
    }

}

public struct APISyncResponse: Equatable {

    public var knowledgeGroups: APISyncDelta<APIKnowledgeGroup>
    public var knowledgeEntries: APISyncDelta<APIKnowledgeEntry>
    public var announcements: APISyncDelta<APIAnnouncement>
    public var events: APISyncDelta<APIEvent>
    public var rooms: APISyncDelta<APIRoom>
    public var tracks: APISyncDelta<APITrack>
    public var conferenceDays: APISyncDelta<APIConferenceDay>
    public var dealers: APISyncDelta<APIDealer>
    public var maps: APISyncDelta<APIMap>
    public var images: APISyncDelta<APIImage>

    public init(knowledgeGroups: APISyncDelta<APIKnowledgeGroup>, knowledgeEntries: APISyncDelta<APIKnowledgeEntry>, announcements: APISyncDelta<APIAnnouncement>, events: APISyncDelta<APIEvent>, rooms: APISyncDelta<APIRoom>, tracks: APISyncDelta<APITrack>, conferenceDays: APISyncDelta<APIConferenceDay>, dealers: APISyncDelta<APIDealer>, maps: APISyncDelta<APIMap>, images: APISyncDelta<APIImage>) {
        self.knowledgeGroups = knowledgeGroups
        self.knowledgeEntries = knowledgeEntries
        self.announcements = announcements
        self.events = events
        self.rooms = rooms
        self.tracks = tracks
        self.conferenceDays = conferenceDays
        self.dealers = dealers
        self.maps = maps
        self.images = images
    }

}
