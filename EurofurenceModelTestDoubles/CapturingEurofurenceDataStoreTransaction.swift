//
//  CapturingEurofurenceDataStoreTransaction.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

public class CapturingEurofurenceDataStoreTransaction: DataStoreTransaction {

    private(set) public var persistedKnowledgeGroups: [KnowledgeGroupCharacteristics] = []
    public func saveKnowledgeGroups(_ knowledgeGroups: [KnowledgeGroupCharacteristics]) {
        self.persistedKnowledgeGroups.append(contentsOf: knowledgeGroups)
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
        persistedKnowledgeEntries.append(contentsOf: knowledgeEntries)
    }

    private(set) public var deletedKnowledgeEntries: [String] = []
    public func deleteKnowledgeEntry(identifier: String) {
        deletedKnowledgeEntries.append(identifier)
    }

    private(set) public var persistedAnnouncements: [AnnouncementCharacteristics] = []
    public func saveAnnouncements(_ announcements: [AnnouncementCharacteristics]) {
        persistedAnnouncements.append(contentsOf: announcements)
    }

    private(set) public var persistedEvents: [EventCharacteristics] = []
    public func saveEvents(_ events: [EventCharacteristics]) {
        for event in events {
            if let idx = persistedEvents.index(where: { $0.identifier == event.identifier }) {
                persistedEvents.remove(at: idx)
            }

            persistedEvents.append(event)
        }
    }

    public func deleteEvent(identifier: String) {
        if let idx = persistedEvents.index(where: { $0.identifier == identifier }) {
            persistedEvents.remove(at: idx)
        }
    }

    private(set) var persistedRooms: [RoomCharacteristics] = []
    public func saveRooms(_ rooms: [RoomCharacteristics]) {
        persistedRooms.append(contentsOf: rooms)
    }

    private(set) public var deletedConferenceDays: [String] = []
    public func deleteConferenceDay(identifier: String) {
        deletedConferenceDays.append(identifier)
    }

    private(set) public var deletedRooms: [String] = []
    public func deleteRoom(identifier: String) {
        deletedRooms.append(identifier)
    }

    private(set) public var persistedTracks: [TrackCharacteristics] = []
    public func saveTracks(_ tracks: [TrackCharacteristics]) {
        persistedTracks.append(contentsOf: tracks)
    }

    private(set) public var deletedTracks: [String] = []
    public func deleteTrack(identifier: String) {
        deletedTracks.append(identifier)
    }

    private(set) public var persistedConferenceDays: [ConferenceDayCharacteristics] = []
    public func saveConferenceDays(_ conferenceDays: [ConferenceDayCharacteristics]) {
        persistedConferenceDays.append(contentsOf: conferenceDays)
    }

    private(set) public var persistedLastRefreshDate: Date?
    public func saveLastRefreshDate(_ lastRefreshDate: Date) {
        persistedLastRefreshDate = lastRefreshDate
    }

    private(set) public var persistedFavouriteEvents = [EventIdentifier]()
    public func saveFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        persistedFavouriteEvents.append(identifier)
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
        persistedDealers.append(contentsOf: dealers)
    }

    public func deleteDealer(identifier: String) {
        if let idx = persistedDealers.index(where: { $0.identifier == identifier }) {
            persistedDealers.remove(at: idx)
        }
    }

    private(set) public var persistedMaps: [MapCharacteristics] = []
    public func saveMaps(_ maps: [MapCharacteristics]) {
        persistedMaps.append(contentsOf: maps)
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
        persistedImages.append(contentsOf: images)
    }

    private(set) public var deletedImages = [String]()
    public func deleteImage(identifier: String) {
        deletedImages.append(identifier)

        if let idx = persistedImages.index(where: { $0.identifier == identifier }) {
            persistedImages.remove(at: idx)
        }
    }

}
