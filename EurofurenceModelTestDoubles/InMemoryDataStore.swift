import EurofurenceModel
import Foundation

open class InMemoryDataStore: DataStore {
    
    public init() {
        
    }
    
    public convenience init(response: ModelCharacteristics) {
        self.init()
        
        performTransaction { (transaction) in
            transaction.saveKnowledgeGroups(response.knowledgeGroups.changed)
            transaction.saveKnowledgeEntries(response.knowledgeEntries.changed)
            transaction.saveAnnouncements(response.announcements.changed)
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
            transaction.saveConferenceDays(response.conferenceDays.changed)
            transaction.saveDealers(response.dealers.changed)
            transaction.saveMaps(response.maps.changed)
            transaction.saveImages(response.images.changed)
        }
    }

    public func fetchAnnouncements() -> [AnnouncementCharacteristics]? {
        return transaction.announcements
    }

    public func fetchLastRefreshDate() -> Date? {
        return transaction.lastRefreshDate
    }

    public func fetchKnowledgeGroups() -> [KnowledgeGroupCharacteristics]? {
        return transaction.knowledgeGroups
    }

    public func fetchKnowledgeEntries() -> [KnowledgeEntryCharacteristics]? {
        return transaction.knowledgeEntries
    }

    public func fetchRooms() -> [RoomCharacteristics]? {
        return transaction.rooms
    }

    public func fetchTracks() -> [TrackCharacteristics]? {
        return transaction.tracks
    }

    public func fetchConferenceDays() -> [ConferenceDayCharacteristics]? {
        return transaction.conferenceDays
    }

    public func fetchEvents() -> [EventCharacteristics]? {
        return transaction.events
    }

    public func fetchFavouriteEventIdentifiers() -> [EventIdentifier]? {
        return Array(transaction.favouriteEvents)
    }

    public func fetchDealers() -> [DealerCharacteristics]? {
        return transaction.dealers
    }

    public func fetchMaps() -> [MapCharacteristics]? {
        return transaction.maps
    }

    public func fetchReadAnnouncementIdentifiers() -> [AnnouncementIdentifier]? {
        return transaction.readAnnouncementIdentifiers
    }

    public func fetchImages() -> [ImageCharacteristics]? {
        return transaction.images
    }
    
    private let transaction = FakeDataStoreTransaction()
    open func performTransaction(_ block: @escaping (DataStoreTransaction) -> Void) {
        block(transaction)
    }

}

private extension Array {
    
    mutating func append<E>(contentsOf other: [Element], identifiedBy: (Element) -> E) where E: Equatable {
        for item in other {
            let key = identifiedBy(item)
            if let index = firstIndex(where: { identifiedBy($0) == key }) {
                self[index] = item
            } else {
                append(item)
            }
        }
    }
    
}

private class FakeDataStoreTransaction: DataStoreTransaction {
    
    fileprivate var knowledgeGroups: [KnowledgeGroupCharacteristics] = []
    func saveKnowledgeGroups(_ knowledgeGroups: [KnowledgeGroupCharacteristics]) {
        self.knowledgeGroups.append(contentsOf: knowledgeGroups, identifiedBy: { $0.identifier })
    }
    
    func deleteKnowledgeGroup(identifier: String) {
        knowledgeGroups.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var knowledgeEntries: [KnowledgeEntryCharacteristics] = []
    func saveKnowledgeEntries(_ knowledgeEntries: [KnowledgeEntryCharacteristics]) {
        self.knowledgeEntries.append(contentsOf: knowledgeEntries, identifiedBy: { $0.identifier })
    }
    
    func deleteKnowledgeEntry(identifier: String) {
        knowledgeEntries.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var announcements: [AnnouncementCharacteristics] = []
    func saveAnnouncements(_ announcements: [AnnouncementCharacteristics]) {
        self.announcements.append(contentsOf: announcements, identifiedBy: { $0.identifier })
    }
    
    fileprivate var events: [EventCharacteristics] = []
    func saveEvents(_ events: [EventCharacteristics]) {
        self.events.append(contentsOf: events, identifiedBy: { $0.identifier })
    }
    
    func deleteEvent(identifier: String) {
        events.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var rooms: [RoomCharacteristics] = []
    func saveRooms(_ rooms: [RoomCharacteristics]) {
        self.rooms.append(contentsOf: rooms, identifiedBy: { $0.identifier })
    }
    
    func deleteConferenceDay(identifier: String) {
        conferenceDays.removeAll(where: { $0.identifier == identifier })
    }
    
    func deleteRoom(identifier: String) {
        rooms.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var tracks: [TrackCharacteristics] = []
    func saveTracks(_ tracks: [TrackCharacteristics]) {
        self.tracks.append(contentsOf: tracks, identifiedBy: { $0.identifier })
    }
    
    func deleteTrack(identifier: String) {
        tracks.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var conferenceDays: [ConferenceDayCharacteristics] = []
    func saveConferenceDays(_ conferenceDays: [ConferenceDayCharacteristics]) {
        self.conferenceDays.append(contentsOf: conferenceDays, identifiedBy: { $0.identifier })
    }
    
    fileprivate var lastRefreshDate: Date?
    func saveLastRefreshDate(_ lastRefreshDate: Date) {
        self.lastRefreshDate = lastRefreshDate
    }
    
    fileprivate var favouriteEvents = Set<EventIdentifier>()
    func saveFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        favouriteEvents.insert(identifier)
    }
    
    func deleteFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        favouriteEvents.remove(identifier)
    }
    
    func deleteAnnouncement(identifier: String) {
        announcements.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var dealers: [DealerCharacteristics] = []
    func saveDealers(_ dealers: [DealerCharacteristics]) {
        self.dealers.append(contentsOf: dealers, identifiedBy: { $0.identifier })
    }
    
    func deleteDealer(identifier: String) {
        dealers.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var maps: [MapCharacteristics] = []
    func saveMaps(_ maps: [MapCharacteristics]) {
        self.maps.append(contentsOf: maps, identifiedBy: { $0.identifier })
    }
    
    func deleteMap(identifier: String) {
        maps.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var readAnnouncementIdentifiers: [AnnouncementIdentifier] = []
    func saveReadAnnouncements(_ announcements: [AnnouncementIdentifier]) {
        readAnnouncementIdentifiers = announcements
    }
    
    fileprivate var images = [ImageCharacteristics]()
    func saveImages(_ images: [ImageCharacteristics]) {
        self.images.append(contentsOf: images, identifiedBy: { $0.identifier })
    }
    
    func deleteImage(identifier: String) {
        images.removeAll(where: { $0.identifier == identifier })
    }
    
}
