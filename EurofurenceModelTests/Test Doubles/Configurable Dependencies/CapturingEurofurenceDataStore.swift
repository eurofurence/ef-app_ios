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

    private func verifySaved<T>(expected: [T], actual: [T]?) -> Bool where T: Equatable {
        return (actual?.contains(elementsFrom: expected)).defaultingTo(false)
    }

    func didSave(_ knowledgeGroups: [KnowledgeGroupCharacteristics]) -> Bool {
        return verifySaved(expected: knowledgeGroups, actual: fetchKnowledgeGroups())
    }

    func didSave(_ knowledgeEntries: [KnowledgeEntryCharacteristics]) -> Bool {
        return verifySaved(expected: knowledgeEntries, actual: fetchKnowledgeEntries())
    }

    func didSave(_ announcements: [AnnouncementCharacteristics]) -> Bool {
        return verifySaved(expected: announcements, actual: fetchAnnouncements())
    }

    func didSave(_ events: [EventCharacteristics]) -> Bool {
        return verifySaved(expected: events, actual: fetchEvents())
    }

    func didSave(_ rooms: [RoomCharacteristics]) -> Bool {
        return verifySaved(expected: rooms, actual: fetchRooms())
    }

    func didSave(_ tracks: [TrackCharacteristics]) -> Bool {
        return verifySaved(expected: tracks, actual: fetchTracks())
    }

    func didSaveLastRefreshTime(_ lastRefreshTime: Date) -> Bool {
        return lastRefreshTime == fetchLastRefreshDate()
    }

    func didFavouriteEvent(_ identifier: EventIdentifier) -> Bool {
        return (fetchFavouriteEventIdentifiers()?.contains(identifier)).defaultingTo(false)
    }

    func didSave(_ dealers: [DealerCharacteristics]) -> Bool {
        return verifySaved(expected: dealers, actual: fetchDealers())
    }

    func didDeleteFavouriteEvent(_ identifier: EventIdentifier) -> Bool {
        return transaction.deletedFavouriteEvents.contains(identifier)
    }

    func didSave(_ conferenceDays: [ConferenceDayCharacteristics]) -> Bool {
        return verifySaved(expected: conferenceDays, actual: fetchConferenceDays())
    }

    func didSave(_ maps: [MapCharacteristics]) -> Bool {
        return verifySaved(expected: maps, actual: fetchMaps())
    }

    func didSaveReadAnnouncement(_ identifier: AnnouncementIdentifier) -> Bool {
        return transaction.persistedReadAnnouncementIdentifiers.contains(identifier)
    }

    func didSaveReadAnnouncements(_ identifiers: [AnnouncementIdentifier]) -> Bool {
        return transaction.persistedReadAnnouncementIdentifiers.contains(elementsFrom: identifiers)
    }

    func didSave(_ images: [ImageCharacteristics]) -> Bool {
        return verifySaved(expected: images, actual: fetchImages())
    }

}
