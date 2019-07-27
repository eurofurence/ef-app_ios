import Foundation

public protocol DataStoreTransaction {
    
    func saveLastRefreshDate(_ lastRefreshDate: Date)
    func saveKnowledgeGroups(_ knowledgeGroups: [KnowledgeGroupCharacteristics])
    func saveKnowledgeEntries(_ knowledgeEntries: [KnowledgeEntryCharacteristics])
    func saveAnnouncements(_ announcements: [AnnouncementCharacteristics])
    func saveEvents(_ events: [EventCharacteristics])
    func saveRooms(_ rooms: [RoomCharacteristics])
    func saveTracks(_ tracks: [TrackCharacteristics])
    func saveConferenceDays(_ conferenceDays: [ConferenceDayCharacteristics])
    func saveFavouriteEventIdentifier(_ identifier: EventIdentifier)
    func saveDealers(_ dealers: [DealerCharacteristics])
    func saveMaps(_ maps: [MapCharacteristics])
    func saveReadAnnouncements(_ announcements: [AnnouncementIdentifier])
    func saveImages(_ images: [ImageCharacteristics])
    
    func deleteFavouriteEventIdentifier(_ identifier: EventIdentifier)
    func deleteKnowledgeGroup(identifier: String)
    func deleteKnowledgeEntry(identifier: String)
    func deleteAnnouncement(identifier: String)
    func deleteEvent(identifier: String)
    func deleteTrack(identifier: String)
    func deleteRoom(identifier: String)
    func deleteConferenceDay(identifier: String)
    func deleteDealer(identifier: String)
    func deleteMap(identifier: String)
    func deleteImage(identifier: String)
    
}
