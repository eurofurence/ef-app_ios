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
        return transaction.persistedFavouriteEvents
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

    private(set) public var capturedKnowledgeGroupsToSave: [KnowledgeGroup]?
    public var transactionInvokedBlock: (() -> Void)?
    public let transaction = CapturingEurofurenceDataStoreTransaction()
    open func performTransaction(_ block: @escaping (DataStoreTransaction) -> Void) {
        block(transaction)
        transactionInvokedBlock?()
    }

}

public extension FakeDataStore {

    public convenience init(response: ModelCharacteristics) {
        self.init()
        save(response)
    }

    public func save(_ response: ModelCharacteristics, lastRefreshDate: Date = Date(), block: ((DataStoreTransaction) -> Void)? = nil) {
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
        guard let actual = actual else { return false }
        
        for element in expected {
            guard actual.contains(element) else { return false }
        }
        
        return true
    }

    public func didSave(_ knowledgeGroups: [KnowledgeGroupCharacteristics]) -> Bool {
        return verifySaved(expected: knowledgeGroups, actual: fetchKnowledgeGroups())
    }

    public func didSave(_ knowledgeEntries: [KnowledgeEntryCharacteristics]) -> Bool {
        return verifySaved(expected: knowledgeEntries, actual: fetchKnowledgeEntries())
    }

    public func didSave(_ announcements: [AnnouncementCharacteristics]) -> Bool {
        return verifySaved(expected: announcements, actual: fetchAnnouncements())
    }

    public func didSave(_ events: [EventCharacteristics]) -> Bool {
        return verifySaved(expected: events, actual: fetchEvents())
    }

    public func didSave(_ rooms: [RoomCharacteristics]) -> Bool {
        return verifySaved(expected: rooms, actual: fetchRooms())
    }

    public func didSave(_ tracks: [TrackCharacteristics]) -> Bool {
        return verifySaved(expected: tracks, actual: fetchTracks())
    }

    public func didSaveLastRefreshTime(_ lastRefreshTime: Date) -> Bool {
        return lastRefreshTime == fetchLastRefreshDate()
    }

    public func didFavouriteEvent(_ identifier: EventIdentifier) -> Bool {
        return (fetchFavouriteEventIdentifiers()?.contains(identifier)).defaultingTo(false)
    }

    public func didSave(_ dealers: [DealerCharacteristics]) -> Bool {
        return verifySaved(expected: dealers, actual: fetchDealers())
    }

    public func didDeleteFavouriteEvent(_ identifier: EventIdentifier) -> Bool {
        return transaction.deletedFavouriteEvents.contains(identifier)
    }

    public func didSave(_ conferenceDays: [ConferenceDayCharacteristics]) -> Bool {
        return verifySaved(expected: conferenceDays, actual: fetchConferenceDays())
    }

    public func didSave(_ maps: [MapCharacteristics]) -> Bool {
        return verifySaved(expected: maps, actual: fetchMaps())
    }

    public func didSaveReadAnnouncement(_ identifier: AnnouncementIdentifier) -> Bool {
        return transaction.persistedReadAnnouncementIdentifiers.contains(identifier)
    }

    public func didSaveReadAnnouncements(_ identifiers: [AnnouncementIdentifier]) -> Bool {
        for item in identifiers {
            guard transaction.persistedReadAnnouncementIdentifiers.contains(item) else { return false }
        }
        
        return true
    }

    public func didSave(_ images: [ImageCharacteristics]) -> Bool {
        return verifySaved(expected: images, actual: fetchImages())
    }

}
