//
//  FakeDataStore.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

open class FakeDataStore: DataStore {
    
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
        return transaction.persistedAnnouncements
    }

    public func fetchLastRefreshDate() -> Date? {
        return transaction.persistedLastRefreshDate
    }

    public func fetchKnowledgeGroups() -> [KnowledgeGroupCharacteristics]? {
        return transaction.persistedKnowledgeGroups
    }

    public func fetchKnowledgeEntries() -> [KnowledgeEntryCharacteristics]? {
        return transaction.persistedKnowledgeEntries
    }

    public func fetchRooms() -> [RoomCharacteristics]? {
        return transaction.persistedRooms
    }

    public func fetchTracks() -> [TrackCharacteristics]? {
        return transaction.persistedTracks
    }

    public func fetchConferenceDays() -> [ConferenceDayCharacteristics]? {
        return transaction.persistedConferenceDays
    }

    public func fetchEvents() -> [EventCharacteristics]? {
        return transaction.persistedEvents
    }

    public func fetchFavouriteEventIdentifiers() -> [EventIdentifier]? {
        return Array(transaction.persistedFavouriteEvents)
    }

    public func fetchDealers() -> [DealerCharacteristics]? {
        return transaction.persistedDealers
    }

    public func fetchMaps() -> [MapCharacteristics]? {
        return transaction.persistedMaps
    }

    public func fetchReadAnnouncementIdentifiers() -> [AnnouncementIdentifier]? {
        return transaction.persistedReadAnnouncementIdentifiers
    }

    public func fetchImages() -> [ImageCharacteristics]? {
        return transaction.persistedImages
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
    
    fileprivate var persistedKnowledgeGroups: [KnowledgeGroupCharacteristics] = []
    func saveKnowledgeGroups(_ knowledgeGroups: [KnowledgeGroupCharacteristics]) {
        persistedKnowledgeGroups.append(contentsOf: knowledgeGroups, identifiedBy: { $0.identifier })
    }
    
    func deleteKnowledgeGroup(identifier: String) {
        persistedKnowledgeGroups.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var persistedKnowledgeEntries: [KnowledgeEntryCharacteristics] = []
    func saveKnowledgeEntries(_ knowledgeEntries: [KnowledgeEntryCharacteristics]) {
        persistedKnowledgeEntries.append(contentsOf: knowledgeEntries, identifiedBy: { $0.identifier })
    }
    
    func deleteKnowledgeEntry(identifier: String) {
        persistedKnowledgeEntries.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var persistedAnnouncements: [AnnouncementCharacteristics] = []
    func saveAnnouncements(_ announcements: [AnnouncementCharacteristics]) {
        persistedAnnouncements.append(contentsOf: announcements, identifiedBy: { $0.identifier })
    }
    
    fileprivate var persistedEvents: [EventCharacteristics] = []
    func saveEvents(_ events: [EventCharacteristics]) {
        persistedEvents.append(contentsOf: events, identifiedBy: { $0.identifier })
    }
    
    func deleteEvent(identifier: String) {
        persistedEvents.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var persistedRooms: [RoomCharacteristics] = []
    func saveRooms(_ rooms: [RoomCharacteristics]) {
        persistedRooms.append(contentsOf: rooms, identifiedBy: { $0.roomIdentifier })
    }
    
    func deleteConferenceDay(identifier: String) {
        persistedConferenceDays.removeAll(where: { $0.identifier == identifier })
    }
    
    func deleteRoom(identifier: String) {
        persistedRooms.removeAll(where: { $0.roomIdentifier == identifier })
    }
    
    fileprivate var persistedTracks: [TrackCharacteristics] = []
    func saveTracks(_ tracks: [TrackCharacteristics]) {
        persistedTracks.append(contentsOf: tracks, identifiedBy: { $0.trackIdentifier })
    }
    
    func deleteTrack(identifier: String) {
        persistedTracks.removeAll(where: { $0.trackIdentifier == identifier })
    }
    
    fileprivate var persistedConferenceDays: [ConferenceDayCharacteristics] = []
    func saveConferenceDays(_ conferenceDays: [ConferenceDayCharacteristics]) {
        persistedConferenceDays.append(contentsOf: conferenceDays, identifiedBy: { $0.identifier })
    }
    
    fileprivate var persistedLastRefreshDate: Date?
    func saveLastRefreshDate(_ lastRefreshDate: Date) {
        persistedLastRefreshDate = lastRefreshDate
    }
    
    fileprivate var persistedFavouriteEvents = Set<EventIdentifier>()
    func saveFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        persistedFavouriteEvents.insert(identifier)
    }
    
    func deleteFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        persistedFavouriteEvents.remove(identifier)
    }
    
    func deleteAnnouncement(identifier: String) {
        persistedAnnouncements.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var persistedDealers: [DealerCharacteristics] = []
    func saveDealers(_ dealers: [DealerCharacteristics]) {
        persistedDealers.append(contentsOf: dealers, identifiedBy: { $0.identifier })
    }
    
    func deleteDealer(identifier: String) {
        persistedDealers.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var persistedMaps: [MapCharacteristics] = []
    func saveMaps(_ maps: [MapCharacteristics]) {
        persistedMaps.append(contentsOf: maps, identifiedBy: { $0.identifier })
    }
    
    func deleteMap(identifier: String) {
        persistedMaps.removeAll(where: { $0.identifier == identifier })
    }
    
    fileprivate var persistedReadAnnouncementIdentifiers: [AnnouncementIdentifier] = []
    func saveReadAnnouncements(_ announcements: [AnnouncementIdentifier]) {
        persistedReadAnnouncementIdentifiers = announcements
    }
    
    fileprivate var persistedImages = [ImageCharacteristics]()
    func saveImages(_ images: [ImageCharacteristics]) {
        persistedImages.append(contentsOf: images, identifiedBy: { $0.identifier })
    }
    
    func deleteImage(identifier: String) {
        persistedImages.removeAll(where: { $0.identifier == identifier })
    }
    
}
