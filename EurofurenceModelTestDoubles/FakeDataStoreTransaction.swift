//
//  FakeDataStoreTransaction.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

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

public class FakeDataStoreTransaction: DataStoreTransaction {

    private(set) var persistedKnowledgeGroups: [KnowledgeGroupCharacteristics] = []
    public func saveKnowledgeGroups(_ knowledgeGroups: [KnowledgeGroupCharacteristics]) {
        persistedKnowledgeGroups.append(contentsOf: knowledgeGroups, identifiedBy: { $0.identifier })
    }

    public func deleteKnowledgeGroup(identifier: String) {
        persistedKnowledgeGroups.removeAll(where: { $0.identifier == identifier })
    }

    private(set) var persistedKnowledgeEntries: [KnowledgeEntryCharacteristics] = []
    public func saveKnowledgeEntries(_ knowledgeEntries: [KnowledgeEntryCharacteristics]) {
        persistedKnowledgeEntries.append(contentsOf: knowledgeEntries, identifiedBy: { $0.identifier })
    }

    public func deleteKnowledgeEntry(identifier: String) {        
        persistedKnowledgeEntries.removeAll(where: { $0.identifier == identifier })
    }

    private(set) var persistedAnnouncements: [AnnouncementCharacteristics] = []
    public func saveAnnouncements(_ announcements: [AnnouncementCharacteristics]) {
        persistedAnnouncements.append(contentsOf: announcements, identifiedBy: { $0.identifier })
    }

    private(set) public var persistedEvents: [EventCharacteristics] = []
    public func saveEvents(_ events: [EventCharacteristics]) {
        persistedEvents.append(contentsOf: events, identifiedBy: { $0.identifier })
    }

    public func deleteEvent(identifier: String) {
        persistedEvents.removeAll(where: { $0.identifier == identifier })
    }

    private(set) var persistedRooms: [RoomCharacteristics] = []
    public func saveRooms(_ rooms: [RoomCharacteristics]) {
        persistedRooms.append(contentsOf: rooms, identifiedBy: { $0.roomIdentifier })
    }

    private(set) public var deletedConferenceDays: [String] = []
    public func deleteConferenceDay(identifier: String) {
        deletedConferenceDays.append(identifier)
        persistedConferenceDays.removeAll(where: { $0.identifier == identifier })
    }

    private(set) public var deletedRooms: [String] = []
    public func deleteRoom(identifier: String) {
        deletedRooms.append(identifier)
        persistedRooms.removeAll(where: { $0.roomIdentifier == identifier })
    }

    private(set) var persistedTracks: [TrackCharacteristics] = []
    public func saveTracks(_ tracks: [TrackCharacteristics]) {
        persistedTracks.append(contentsOf: tracks, identifiedBy: { $0.trackIdentifier })
    }

    private(set) public var deletedTracks: [String] = []
    public func deleteTrack(identifier: String) {
        deletedTracks.append(identifier)
        persistedTracks.removeAll(where: { $0.trackIdentifier == identifier })
    }

    private(set) var persistedConferenceDays: [ConferenceDayCharacteristics] = []
    public func saveConferenceDays(_ conferenceDays: [ConferenceDayCharacteristics]) {
        persistedConferenceDays.append(contentsOf: conferenceDays, identifiedBy: { $0.identifier })
    }

    private(set) var persistedLastRefreshDate: Date?
    public func saveLastRefreshDate(_ lastRefreshDate: Date) {
        persistedLastRefreshDate = lastRefreshDate
    }

    private(set) var persistedFavouriteEvents = Set<EventIdentifier>()
    public func saveFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        persistedFavouriteEvents.insert(identifier)
    }

    public func deleteFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        persistedFavouriteEvents.remove(identifier)
    }

    public func deleteAnnouncement(identifier: String) {
        persistedAnnouncements.removeAll(where: { $0.identifier == identifier })
    }

    private(set) var persistedDealers: [DealerCharacteristics] = []
    public func saveDealers(_ dealers: [DealerCharacteristics]) {
        persistedDealers.append(contentsOf: dealers, identifiedBy: { $0.identifier })
    }

    public func deleteDealer(identifier: String) {
        persistedDealers.removeAll(where: { $0.identifier == identifier })
    }

    private(set) var persistedMaps: [MapCharacteristics] = []
    public func saveMaps(_ maps: [MapCharacteristics]) {
        persistedMaps.append(contentsOf: maps, identifiedBy: { $0.identifier })
    }

    public func deleteMap(identifier: String) {
        persistedMaps.removeAll(where: { $0.identifier == identifier })
    }

    private(set) var persistedReadAnnouncementIdentifiers: [AnnouncementIdentifier] = []
    public func saveReadAnnouncements(_ announcements: [AnnouncementIdentifier]) {
        persistedReadAnnouncementIdentifiers = announcements
    }

    private(set) var persistedImages = [ImageCharacteristics]()
    public func saveImages(_ images: [ImageCharacteristics]) {
        persistedImages.append(contentsOf: images, identifiedBy: { $0.identifier })
    }

    private(set) public var deletedImages = [String]()
    public func deleteImage(identifier: String) {
        deletedImages.append(identifier)
        persistedImages.removeAll(where: { $0.identifier == identifier })
    }

}
