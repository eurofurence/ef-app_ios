//
//  CapturingEurofurenceDataStoreTransaction.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

extension Array {
    
    mutating func append<E>(contentsOf other: [Element], distinct: (Element) -> E) where E: Equatable {
        for item in other {
            let key = distinct(item)
            if let index = firstIndex(where: { distinct($0) == key }) {
                self[index] = item
            } else {
                append(item)
            }
        }
    }
    
}

public class CapturingEurofurenceDataStoreTransaction: DataStoreTransaction {

    private(set) public var persistedKnowledgeGroups: [KnowledgeGroupCharacteristics] = []
    public func saveKnowledgeGroups(_ knowledgeGroups: [KnowledgeGroupCharacteristics]) {
        persistedKnowledgeGroups.append(contentsOf: knowledgeGroups, distinct: { $0.identifier })
    }

    private(set) public var deletedKnowledgeGroups: [String] = []
    public func deleteKnowledgeGroup(identifier: String) {
        deletedKnowledgeGroups.append(identifier)

        if let idx = persistedKnowledgeGroups.index(where: { $0.identifier == identifier }) {
            persistedKnowledgeGroups.remove(at: idx)
        }
    }

    private(set) public var persistedKnowledgeEntries: [KnowledgeEntryCharacteristics] = []
    public func saveKnowledgeEntries(_ knowledgeEntries: [KnowledgeEntryCharacteristics]) {
        persistedKnowledgeEntries.append(contentsOf: knowledgeEntries, distinct: { $0.identifier })
    }

    private(set) public var deletedKnowledgeEntries: [String] = []
    public func deleteKnowledgeEntry(identifier: String) {
        deletedKnowledgeEntries.append(identifier)
        
        persistedKnowledgeEntries.removeAll(where: { $0.identifier == identifier })
    }

    private(set) public var persistedAnnouncements: [AnnouncementCharacteristics] = []
    public func saveAnnouncements(_ announcements: [AnnouncementCharacteristics]) {
        persistedAnnouncements.append(contentsOf: announcements, distinct: { $0.identifier })
    }

    private(set) public var persistedEvents: [EventCharacteristics] = []
    public func saveEvents(_ events: [EventCharacteristics]) {
        persistedEvents.append(contentsOf: events, distinct: { $0.identifier })
    }

    public func deleteEvent(identifier: String) {
        if let idx = persistedEvents.index(where: { $0.identifier == identifier }) {
            persistedEvents.remove(at: idx)
        }
    }

    private(set) var persistedRooms: [RoomCharacteristics] = []
    public func saveRooms(_ rooms: [RoomCharacteristics]) {
        persistedRooms.append(contentsOf: rooms, distinct: { $0.roomIdentifier })
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

    private(set) public var persistedTracks: [TrackCharacteristics] = []
    public func saveTracks(_ tracks: [TrackCharacteristics]) {
        persistedTracks.append(contentsOf: tracks, distinct: { $0.trackIdentifier })
    }

    private(set) public var deletedTracks: [String] = []
    public func deleteTrack(identifier: String) {
        deletedTracks.append(identifier)
        persistedTracks.removeAll(where: { $0.trackIdentifier == identifier })
    }

    private(set) public var persistedConferenceDays: [ConferenceDayCharacteristics] = []
    public func saveConferenceDays(_ conferenceDays: [ConferenceDayCharacteristics]) {
        persistedConferenceDays.append(contentsOf: conferenceDays, distinct: { $0.identifier })
    }

    private(set) public var persistedLastRefreshDate: Date?
    public func saveLastRefreshDate(_ lastRefreshDate: Date) {
        persistedLastRefreshDate = lastRefreshDate
    }

    private(set) public var persistedFavouriteEvents = Set<EventIdentifier>()
    public func saveFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        persistedFavouriteEvents.insert(identifier)
    }

    private(set) public var deletedFavouriteEvents = [EventIdentifier]()
    public func deleteFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        deletedFavouriteEvents.append(identifier)
    }

    public func deleteAnnouncement(identifier: String) {
        if let idx = persistedAnnouncements.index(where: { $0.identifier == identifier }) {
            persistedAnnouncements.remove(at: idx)
        }
    }

    private(set) public var persistedDealers: [DealerCharacteristics] = []
    public func saveDealers(_ dealers: [DealerCharacteristics]) {
        persistedDealers.append(contentsOf: dealers, distinct: { $0.identifier })
    }

    public func deleteDealer(identifier: String) {
        if let idx = persistedDealers.index(where: { $0.identifier == identifier }) {
            persistedDealers.remove(at: idx)
        }
    }

    private(set) public var persistedMaps: [MapCharacteristics] = []
    public func saveMaps(_ maps: [MapCharacteristics]) {
        persistedMaps.append(contentsOf: maps, distinct: { $0.identifier })
    }

    public func deleteMap(identifier: String) {
        if let idx = persistedMaps.index(where: { $0.identifier == identifier }) {
            persistedMaps.remove(at: idx)
        }
    }

    private(set) public var persistedReadAnnouncementIdentifiers: [AnnouncementIdentifier] = []
    public func saveReadAnnouncements(_ announcements: [AnnouncementIdentifier]) {
        persistedReadAnnouncementIdentifiers = announcements
    }

    private(set) public var persistedImages = [ImageCharacteristics]()
    public func saveImages(_ images: [ImageCharacteristics]) {
        persistedImages.append(contentsOf: images, distinct: { $0.identifier })
    }

    private(set) public var deletedImages = [String]()
    public func deleteImage(identifier: String) {
        deletedImages.append(identifier)

        if let idx = persistedImages.index(where: { $0.identifier == identifier }) {
            persistedImages.remove(at: idx)
        }
    }

}
