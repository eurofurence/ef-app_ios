//
//  CapturingEurofurenceDataStoreTransaction.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingEurofurenceDataStoreTransaction: DataStoreTransaction {

    private(set) var persistedKnowledgeGroups: [KnowledgeGroupCharacteristics] = []
    func saveKnowledgeGroups(_ knowledgeGroups: [KnowledgeGroupCharacteristics]) {
        self.persistedKnowledgeGroups.append(contentsOf: knowledgeGroups)
    }

    private(set) var deletedKnowledgeGroups: [String] = []
    func deleteKnowledgeGroup(identifier: String) {
        deletedKnowledgeGroups.append(identifier)

        if let idx = persistedKnowledgeGroups.index(where: { $0.identifier == identifier }) {
            persistedKnowledgeGroups.remove(at: idx)
        }
    }

    private(set) var persistedKnowledgeEntries: [KnowledgeEntryCharacteristics] = []
    func saveKnowledgeEntries(_ knowledgeEntries: [KnowledgeEntryCharacteristics]) {
        persistedKnowledgeEntries.append(contentsOf: knowledgeEntries)
    }

    private(set) var deletedKnowledgeEntries: [String] = []
    func deleteKnowledgeEntry(identifier: String) {
        deletedKnowledgeEntries.append(identifier)
    }

    private(set) var persistedAnnouncements: [AnnouncementCharacteristics] = []
    func saveAnnouncements(_ announcements: [AnnouncementCharacteristics]) {
        persistedAnnouncements.append(contentsOf: announcements)
    }

    private(set) var persistedEvents: [EventCharacteristics] = []
    func saveEvents(_ events: [EventCharacteristics]) {
        for event in events {
            if let idx = persistedEvents.index(where: { $0.identifier == event.identifier }) {
                persistedEvents.remove(at: idx)
            }

            persistedEvents.append(event)
        }
    }

    func deleteEvent(identifier: String) {
        if let idx = persistedEvents.index(where: { $0.identifier == identifier }) {
            persistedEvents.remove(at: idx)
        }
    }

    private(set) var persistedRooms: [RoomCharacteristics] = []
    func saveRooms(_ rooms: [RoomCharacteristics]) {
        persistedRooms.append(contentsOf: rooms)
    }

    private(set) var deletedConferenceDays: [String] = []
    func deleteConferenceDay(identifier: String) {
        deletedConferenceDays.append(identifier)
    }

    private(set) var deletedRooms: [String] = []
    func deleteRoom(identifier: String) {
        deletedRooms.append(identifier)
    }

    private(set) var persistedTracks: [TrackCharacteristics] = []
    func saveTracks(_ tracks: [TrackCharacteristics]) {
        persistedTracks.append(contentsOf: tracks)
    }

    private(set) var deletedTracks: [String] = []
    func deleteTrack(identifier: String) {
        deletedTracks.append(identifier)
    }

    private(set) var persistedConferenceDays: [ConferenceDayCharacteristics] = []
    func saveConferenceDays(_ conferenceDays: [ConferenceDayCharacteristics]) {
        persistedConferenceDays.append(contentsOf: conferenceDays)
    }

    private(set) var persistedLastRefreshDate: Date?
    func saveLastRefreshDate(_ lastRefreshDate: Date) {
        persistedLastRefreshDate = lastRefreshDate
    }

    private(set) var persistedFavouriteEvents = [EventIdentifier]()
    func saveFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        persistedFavouriteEvents.append(identifier)
    }

    private(set) var deletedFavouriteEvents = [EventIdentifier]()
    func deleteFavouriteEventIdentifier(_ identifier: EventIdentifier) {
        deletedFavouriteEvents.append(identifier)
    }

    func deleteAnnouncement(identifier: String) {
        if let idx = persistedAnnouncements.index(where: { $0.identifier == identifier }) {
            persistedAnnouncements.remove(at: idx)
        }
    }

    private(set) var persistedDealers: [DealerCharacteristics] = []
    func saveDealers(_ dealers: [DealerCharacteristics]) {
        persistedDealers.append(contentsOf: dealers)
    }

    func deleteDealer(identifier: String) {
        if let idx = persistedDealers.index(where: { $0.identifier == identifier }) {
            persistedDealers.remove(at: idx)
        }
    }

    private(set) var persistedMaps: [MapCharacteristics] = []
    func saveMaps(_ maps: [MapCharacteristics]) {
        persistedMaps.append(contentsOf: maps)
    }

    func deleteMap(identifier: String) {
        if let idx = persistedMaps.index(where: { $0.identifier == identifier }) {
            persistedMaps.remove(at: idx)
        }
    }

    private(set) var persistedReadAnnouncementIdentifiers: [AnnouncementIdentifier] = []
    func saveReadAnnouncements(_ announcements: [AnnouncementIdentifier]) {
        persistedReadAnnouncementIdentifiers = announcements
    }

    private(set) var persistedImages = [ImageCharacteristics]()
    func saveImages(_ images: [ImageCharacteristics]) {
        persistedImages.append(contentsOf: images)
    }

    private(set) var deletedImages = [String]()
    func deleteImage(identifier: String) {
        deletedImages.append(identifier)

        if let idx = persistedImages.index(where: { $0.identifier == identifier }) {
            persistedImages.remove(at: idx)
        }
    }

}
