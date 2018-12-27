//
//  CapturingEurofurenceDataStoreTransaction.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingEurofurenceDataStoreTransaction: EurofurenceDataStoreTransaction {

    private(set) var persistedKnowledgeGroups: [APIKnowledgeGroup] = []
    func saveKnowledgeGroups(_ knowledgeGroups: [APIKnowledgeGroup]) {
        self.persistedKnowledgeGroups.append(contentsOf: knowledgeGroups)
    }

    private(set) var deletedKnowledgeGroups: [String] = []
    func deleteKnowledgeGroup(identifier: String) {
        deletedKnowledgeGroups.append(identifier)

        if let idx = persistedKnowledgeGroups.index(where: { $0.identifier == identifier }) {
            persistedKnowledgeGroups.remove(at: idx)
        }
    }

    private(set) var persistedKnowledgeEntries: [APIKnowledgeEntry] = []
    func saveKnowledgeEntries(_ knowledgeEntries: [APIKnowledgeEntry]) {
        persistedKnowledgeEntries.append(contentsOf: knowledgeEntries)
    }

    private(set) var deletedKnowledgeEntries: [String] = []
    func deleteKnowledgeEntry(identifier: String) {
        deletedKnowledgeEntries.append(identifier)
    }

    private(set) var persistedAnnouncements: [APIAnnouncement] = []
    func saveAnnouncements(_ announcements: [APIAnnouncement]) {
        persistedAnnouncements.append(contentsOf: announcements)
    }

    private(set) var persistedEvents: [APIEvent] = []
    func saveEvents(_ events: [APIEvent]) {
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

    private(set) var persistedRooms: [APIRoom] = []
    func saveRooms(_ rooms: [APIRoom]) {
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

    private(set) var persistedTracks: [APITrack] = []
    func saveTracks(_ tracks: [APITrack]) {
        persistedTracks.append(contentsOf: tracks)
    }

    private(set) var deletedTracks: [String] = []
    func deleteTrack(identifier: String) {
        deletedTracks.append(identifier)
    }

    private(set) var persistedConferenceDays: [APIConferenceDay] = []
    func saveConferenceDays(_ conferenceDays: [APIConferenceDay]) {
        persistedConferenceDays.append(contentsOf: conferenceDays)
    }

    private(set) var persistedLastRefreshDate: Date?
    func saveLastRefreshDate(_ lastRefreshDate: Date) {
        persistedLastRefreshDate = lastRefreshDate
    }

    private(set) var persistedFavouriteEvents = [Event.Identifier]()
    func saveFavouriteEventIdentifier(_ identifier: Event.Identifier) {
        persistedFavouriteEvents.append(identifier)
    }

    private(set) var deletedFavouriteEvents = [Event.Identifier]()
    func deleteFavouriteEventIdentifier(_ identifier: Event.Identifier) {
        deletedFavouriteEvents.append(identifier)
    }

    func deleteAnnouncement(identifier: String) {
        if let idx = persistedAnnouncements.index(where: { $0.identifier == identifier }) {
            persistedAnnouncements.remove(at: idx)
        }
    }

    private(set) var persistedDealers: [APIDealer] = []
    func saveDealers(_ dealers: [APIDealer]) {
        persistedDealers.append(contentsOf: dealers)
    }

    func deleteDealer(identifier: String) {
        if let idx = persistedDealers.index(where: { $0.identifier == identifier }) {
            persistedDealers.remove(at: idx)
        }
    }

    private(set) var persistedMaps: [APIMap] = []
    func saveMaps(_ maps: [APIMap]) {
        persistedMaps.append(contentsOf: maps)
    }

    func deleteMap(identifier: String) {
        if let idx = persistedMaps.index(where: { $0.identifier == identifier }) {
            persistedMaps.remove(at: idx)
        }
    }

    private(set) var persistedReadAnnouncementIdentifiers: [Announcement.Identifier] = []
    func saveReadAnnouncements(_ announcements: [Announcement.Identifier]) {
        persistedReadAnnouncementIdentifiers = announcements
    }

    private(set) var persistedImages = [APIImage]()
    func saveImages(_ images: [APIImage]) {
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
