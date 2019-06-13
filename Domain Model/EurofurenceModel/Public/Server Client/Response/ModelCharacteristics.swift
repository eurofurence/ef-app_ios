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

    public var conventionIdentifier: String
    public var knowledgeGroups: Update<KnowledgeGroupCharacteristics>
    public var knowledgeEntries: Update<KnowledgeEntryCharacteristics>
    public var announcements: Update<AnnouncementCharacteristics>
    public var events: Update<EventCharacteristics>
    public var rooms: Update<RoomCharacteristics>
    public var tracks: Update<TrackCharacteristics>
    public var conferenceDays: Update<ConferenceDayCharacteristics>
    public var dealers: Update<DealerCharacteristics>
    public var maps: Update<MapCharacteristics>
    public var images: Update<ImageCharacteristics>

    public init(conventionIdentifier: String,
                knowledgeGroups: Update<KnowledgeGroupCharacteristics>,
                knowledgeEntries: Update<KnowledgeEntryCharacteristics>,
                announcements: Update<AnnouncementCharacteristics>,
                events: Update<EventCharacteristics>,
                rooms: Update<RoomCharacteristics>,
                tracks: Update<TrackCharacteristics>,
                conferenceDays: Update<ConferenceDayCharacteristics>,
                dealers: Update<DealerCharacteristics>,
                maps: Update<MapCharacteristics>,
                images: Update<ImageCharacteristics>) {
        self.conventionIdentifier = conventionIdentifier
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
