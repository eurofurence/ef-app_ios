//
//  CapturingEurofurenceDataStore.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class CapturingEurofurenceDataStore: EurofurenceDataStore {

    func getSavedAnnouncements() -> [APIAnnouncement]? {
        return transaction.persistedAnnouncements
    }

    func getLastRefreshDate() -> Date? {
        return transaction.persistedLastRefreshDate
    }

    func getSavedKnowledgeGroups() -> [APIKnowledgeGroup]? {
        return transaction.persistedKnowledgeGroups
    }

    func getSavedKnowledgeEntries() -> [APIKnowledgeEntry]? {
        return transaction.persistedKnowledgeEntries
    }

    func getSavedRooms() -> [APIRoom]? {
        return transaction.persistedRooms
    }

    func getSavedTracks() -> [APITrack]? {
        return transaction.persistedTracks
    }

    func getSavedConferenceDays() -> [APIConferenceDay]? {
        return transaction.persistedConferenceDays
    }

    func getSavedEvents() -> [APIEvent]? {
        return transaction.persistedEvents
    }

    func getSavedFavouriteEventIdentifiers() -> [Event.Identifier]? {
        return transaction.persistedFavouriteEvents
    }

    func getSavedDealers() -> [APIDealer]? {
        return transaction.persistedDealers
    }

    func getSavedMaps() -> [APIMap]? {
        return transaction.persistedMaps
    }

    func getSavedReadAnnouncementIdentifiers() -> [Announcement.Identifier]? {
        return transaction.persistedReadAnnouncementIdentifiers
    }

    func getSavedImages() -> [APIImage]? {
        return transaction.persistedImages
    }

    private(set) var capturedKnowledgeGroupsToSave: [KnowledgeGroup]?
    var transactionInvokedBlock: (() -> Void)?
    let transaction = CapturingEurofurenceDataStoreTransaction()
    func performTransaction(_ block: @escaping (EurofurenceDataStoreTransaction) -> Void) {
        block(transaction)
        transactionInvokedBlock?()
    }

}

extension CapturingEurofurenceDataStore {

    func save(_ response: APISyncResponse, lastRefreshDate: Date = Date(), block: ((EurofurenceDataStoreTransaction) -> Void)? = nil) {
        performTransaction { (transaction) in
            transaction.saveLastRefreshDate(lastRefreshDate)
            transaction.saveKnowledgeGroups(response.knowledgeGroups.changed)
            transaction.saveKnowledgeEntries(response.knowledgeEntries.changed)
            transaction.saveAnnouncements(response.announcements.changed)
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
            transaction.saveConferenceDays(response.conferenceDays.changed)
            transaction.saveDealers(response.dealers.changed)
            transaction.saveMaps(response.maps.changed)

            block?(transaction)
        }
    }

    func didSave(_ knowledgeGroups: [APIKnowledgeGroup]) -> Bool {
        return transaction.persistedKnowledgeGroups.contains(elementsFrom: knowledgeGroups)
    }

    func didSave(_ knowledgeEntries: [APIKnowledgeEntry]) -> Bool {
        return transaction.persistedKnowledgeEntries.contains(elementsFrom: knowledgeEntries)
    }

    func didSave(_ announcements: [APIAnnouncement]) -> Bool {
        return transaction.persistedAnnouncements.contains(elementsFrom: announcements)
    }

    func didSave(_ events: [APIEvent]) -> Bool {
        return transaction.persistedEvents.contains(elementsFrom: events)
    }

    func didSave(_ events: [APIRoom]) -> Bool {
        return transaction.persistedRooms.contains(elementsFrom: events)
    }

    func didSave(_ tracks: [APITrack]) -> Bool {
        return transaction.persistedTracks.contains(elementsFrom: tracks)
    }

    func didSaveLastRefreshTime(_ lastRefreshTime: Date) -> Bool {
        return lastRefreshTime == transaction.persistedLastRefreshDate
    }

    func didFavouriteEvent(_ identifier: Event.Identifier) -> Bool {
        return transaction.persistedFavouriteEvents.contains(identifier)
    }

    func didSave(_ dealers: [APIDealer]) -> Bool {
        return transaction.persistedDealers.contains(elementsFrom: dealers)
    }

    func didDeleteFavouriteEvent(_ identifier: Event.Identifier) -> Bool {
        return transaction.deletedFavouriteEvents.contains(identifier)
    }

    func didSave(_ conferenceDays: [APIConferenceDay]) -> Bool {
        return transaction.persistedConferenceDays.contains(elementsFrom: conferenceDays)
    }

    func didSave(_ maps: [APIMap]) -> Bool {
        return transaction.persistedMaps.contains(elementsFrom: maps)
    }

    func didSaveReadAnnouncement(_ identifier: Announcement.Identifier) -> Bool {
        return transaction.persistedReadAnnouncementIdentifiers.contains(identifier)
    }

    func didSaveReadAnnouncements(_ identifiers: [Announcement.Identifier]) -> Bool {
        return transaction.persistedReadAnnouncementIdentifiers.contains(elementsFrom: identifiers)
    }

    func didSave(_ images: [APIImage]) -> Bool {
        return transaction.persistedImages.contains(elementsFrom: images)
    }

}
