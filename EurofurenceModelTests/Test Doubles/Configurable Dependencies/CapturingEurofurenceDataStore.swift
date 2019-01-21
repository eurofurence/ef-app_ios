//
//  CapturingEurofurenceDataStore.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingEurofurenceDataStore: DataStore {

    func fetchAnnouncements() -> [AnnouncementCharacteristics]? {
        return transaction.persistedAnnouncements
    }

    func fetchLastRefreshDate() -> Date? {
        return transaction.persistedLastRefreshDate
    }

    func fetchKnowledgeGroups() -> [KnowledgeGroupCharacteristics]? {
        return transaction.persistedKnowledgeGroups
    }

    func fetchKnowledgeEntries() -> [KnowledgeEntryCharacteristics]? {
        return transaction.persistedKnowledgeEntries
    }

    func fetchRooms() -> [RoomCharacteristics]? {
        return transaction.persistedRooms
    }

    func fetchTracks() -> [TrackCharacteristics]? {
        return transaction.persistedTracks
    }

    func fetchConferenceDays() -> [ConferenceDayCharacteristics]? {
        return transaction.persistedConferenceDays
    }

    func fetchEvents() -> [EventCharacteristics]? {
        return transaction.persistedEvents
    }

    func fetchFavouriteEventIdentifiers() -> [EventIdentifier]? {
        return transaction.persistedFavouriteEvents
    }

    func fetchDealers() -> [DealerCharacteristics]? {
        return transaction.persistedDealers
    }

    func fetchMaps() -> [MapCharacteristics]? {
        return transaction.persistedMaps
    }

    func fetchReadAnnouncementIdentifiers() -> [AnnouncementIdentifier]? {
        return transaction.persistedReadAnnouncementIdentifiers
    }

    func fetchImages() -> [ImageCharacteristics]? {
        return transaction.persistedImages
    }

    private(set) var capturedKnowledgeGroupsToSave: [KnowledgeGroup]?
    var transactionInvokedBlock: (() -> Void)?
    let transaction = CapturingEurofurenceDataStoreTransaction()
    func performTransaction(_ block: @escaping (DataStoreTransaction) -> Void) {
        block(transaction)
        transactionInvokedBlock?()
    }

}

extension CapturingEurofurenceDataStore {

    convenience init(response: ModelCharacteristics) {
        self.init()
        save(response)
    }

    func save(_ response: ModelCharacteristics, lastRefreshDate: Date = Date(), block: ((DataStoreTransaction) -> Void)? = nil) {
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

    func didSave(_ knowledgeGroups: [KnowledgeGroupCharacteristics]) -> Bool {
        return transaction.persistedKnowledgeGroups.contains(elementsFrom: knowledgeGroups)
    }

    func didSave(_ knowledgeEntries: [KnowledgeEntryCharacteristics]) -> Bool {
        return transaction.persistedKnowledgeEntries.contains(elementsFrom: knowledgeEntries)
    }

    func didSave(_ announcements: [AnnouncementCharacteristics]) -> Bool {
        return transaction.persistedAnnouncements.contains(elementsFrom: announcements)
    }

    func didSave(_ events: [EventCharacteristics]) -> Bool {
        return transaction.persistedEvents.contains(elementsFrom: events)
    }

    func didSave(_ events: [RoomCharacteristics]) -> Bool {
        return transaction.persistedRooms.contains(elementsFrom: events)
    }

    func didSave(_ tracks: [TrackCharacteristics]) -> Bool {
        return transaction.persistedTracks.contains(elementsFrom: tracks)
    }

    func didSaveLastRefreshTime(_ lastRefreshTime: Date) -> Bool {
        return lastRefreshTime == transaction.persistedLastRefreshDate
    }

    func didFavouriteEvent(_ identifier: EventIdentifier) -> Bool {
        return transaction.persistedFavouriteEvents.contains(identifier)
    }

    func didSave(_ dealers: [DealerCharacteristics]) -> Bool {
        return transaction.persistedDealers.contains(elementsFrom: dealers)
    }

    func didDeleteFavouriteEvent(_ identifier: EventIdentifier) -> Bool {
        return transaction.deletedFavouriteEvents.contains(identifier)
    }

    func didSave(_ conferenceDays: [ConferenceDayCharacteristics]) -> Bool {
        return transaction.persistedConferenceDays.contains(elementsFrom: conferenceDays)
    }

    func didSave(_ maps: [MapCharacteristics]) -> Bool {
        return transaction.persistedMaps.contains(elementsFrom: maps)
    }

    func didSaveReadAnnouncement(_ identifier: AnnouncementIdentifier) -> Bool {
        return transaction.persistedReadAnnouncementIdentifiers.contains(identifier)
    }

    func didSaveReadAnnouncements(_ identifiers: [AnnouncementIdentifier]) -> Bool {
        return transaction.persistedReadAnnouncementIdentifiers.contains(elementsFrom: identifiers)
    }

    func didSave(_ images: [ImageCharacteristics]) -> Bool {
        return transaction.persistedImages.contains(elementsFrom: images)
    }

}
