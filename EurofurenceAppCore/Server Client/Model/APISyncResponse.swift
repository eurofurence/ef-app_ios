//
//  APISyncResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct APISyncResponse: Equatable {

    public struct Delta<T>: Equatable where T: Equatable {

        public var changed: [T]
        public var deleted: [String]
        public var removeAllBeforeInsert: Bool

        public init(changed: [T] = [], deleted: [String] = [], removeAllBeforeInsert: Bool = false) {
            self.changed = changed
            self.deleted = deleted
            self.removeAllBeforeInsert = removeAllBeforeInsert
        }

    }

    public var knowledgeGroups: APISyncResponse.Delta<APIKnowledgeGroup>
    public var knowledgeEntries: APISyncResponse.Delta<APIKnowledgeEntry>
    public var announcements: APISyncResponse.Delta<APIAnnouncement>
    public var events: APISyncResponse.Delta<APIEvent>
    public var rooms: APISyncResponse.Delta<APIRoom>
    public var tracks: APISyncResponse.Delta<APITrack>
    public var conferenceDays: APISyncResponse.Delta<APIConferenceDay>
    public var dealers: APISyncResponse.Delta<APIDealer>
    public var maps: APISyncResponse.Delta<APIMap>
    public var images: APISyncResponse.Delta<APIImage>

    public init(knowledgeGroups: APISyncResponse.Delta<APIKnowledgeGroup>, knowledgeEntries: APISyncResponse.Delta<APIKnowledgeEntry>, announcements: APISyncResponse.Delta<APIAnnouncement>, events: APISyncResponse.Delta<APIEvent>, rooms: APISyncResponse.Delta<APIRoom>, tracks: APISyncResponse.Delta<APITrack>, conferenceDays: APISyncResponse.Delta<APIConferenceDay>, dealers: APISyncResponse.Delta<APIDealer>, maps: APISyncResponse.Delta<APIMap>, images: APISyncResponse.Delta<APIImage>) {
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
