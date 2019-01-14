//
//  ModelCharacteristics.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct ModelCharacteristics: Equatable {

    public struct Update<T>: Equatable where T: Equatable {

        public var changed: [T]
        public var deleted: [String]
        public var removeAllBeforeInsert: Bool

        public init(changed: [T] = [], deleted: [String] = [], removeAllBeforeInsert: Bool = false) {
            self.changed = changed
            self.deleted = deleted
            self.removeAllBeforeInsert = removeAllBeforeInsert
        }

    }

    public var knowledgeGroups: ModelCharacteristics.Update<KnowledgeGroupCharacteristics>
    public var knowledgeEntries: ModelCharacteristics.Update<KnowledgeEntryCharacteristics>
    public var announcements: ModelCharacteristics.Update<AnnouncementCharacteristics>
    public var events: ModelCharacteristics.Update<EventCharacteristics>
    public var rooms: ModelCharacteristics.Update<RoomCharacteristics>
    public var tracks: ModelCharacteristics.Update<TrackCharacteristics>
    public var conferenceDays: ModelCharacteristics.Update<ConferenceDayCharacteristics>
    public var dealers: ModelCharacteristics.Update<DealerCharacteristics>
    public var maps: ModelCharacteristics.Update<MapCharacteristics>
    public var images: ModelCharacteristics.Update<ImageCharacteristics>

    public init(knowledgeGroups: ModelCharacteristics.Update<KnowledgeGroupCharacteristics>, knowledgeEntries: ModelCharacteristics.Update<KnowledgeEntryCharacteristics>, announcements: ModelCharacteristics.Update<AnnouncementCharacteristics>, events: ModelCharacteristics.Update<EventCharacteristics>, rooms: ModelCharacteristics.Update<RoomCharacteristics>, tracks: ModelCharacteristics.Update<TrackCharacteristics>, conferenceDays: ModelCharacteristics.Update<ConferenceDayCharacteristics>, dealers: ModelCharacteristics.Update<DealerCharacteristics>, maps: ModelCharacteristics.Update<MapCharacteristics>, images: ModelCharacteristics.Update<ImageCharacteristics>) {
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
