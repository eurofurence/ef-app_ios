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
    
    public let transaction = FakeDataStoreTransaction()
    open func performTransaction(_ block: @escaping (DataStoreTransaction) -> Void) {
        block(transaction)
    }

}
