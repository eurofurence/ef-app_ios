//
//  DataStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public protocol DataStore {

    func performTransaction(_ block: @escaping (DataStoreTransaction) -> Void)

    func fetchLastRefreshDate() -> Date?
    func fetchKnowledgeGroups() -> [KnowledgeGroupCharacteristics]?
    func fetchKnowledgeEntries() -> [KnowledgeEntryCharacteristics]?
    func fetchRooms() -> [RoomCharacteristics]?
    func fetchTracks() -> [TrackCharacteristics]?
    func fetchEvents() -> [EventCharacteristics]?
    func fetchAnnouncements() -> [AnnouncementCharacteristics]?
    func fetchConferenceDays() -> [ConferenceDayCharacteristics]?
    func fetchFavouriteEventIdentifiers() -> [EventIdentifier]?
    func fetchDealers() -> [DealerCharacteristics]?
    func fetchMaps() -> [MapCharacteristics]?
    func fetchReadAnnouncementIdentifiers() -> [AnnouncementIdentifier]?
    func fetchImages() -> [ImageCharacteristics]?

}
