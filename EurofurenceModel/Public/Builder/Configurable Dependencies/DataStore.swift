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

    func getLastRefreshDate() -> Date?
    func getSavedKnowledgeGroups() -> [APIKnowledgeGroup]?
    func getSavedKnowledgeEntries() -> [APIKnowledgeEntry]?
    func getSavedRooms() -> [APIRoom]?
    func getSavedTracks() -> [APITrack]?
    func getSavedEvents() -> [APIEvent]?
    func getSavedAnnouncements() -> [APIAnnouncement]?
    func getSavedConferenceDays() -> [APIConferenceDay]?
    func getSavedFavouriteEventIdentifiers() -> [EventIdentifier]?
    func getSavedDealers() -> [APIDealer]?
    func getSavedMaps() -> [APIMap]?
    func getSavedReadAnnouncementIdentifiers() -> [AnnouncementIdentifier]?
    func getSavedImages() -> [APIImage]?

}

public protocol DataStoreTransaction {

    func saveLastRefreshDate(_ lastRefreshDate: Date)
    func saveKnowledgeGroups(_ knowledgeGroups: [APIKnowledgeGroup])
    func saveKnowledgeEntries(_ knowledgeEntries: [APIKnowledgeEntry])
    func saveAnnouncements(_ announcements: [APIAnnouncement])
    func saveEvents(_ events: [APIEvent])
    func saveRooms(_ rooms: [APIRoom])
    func saveTracks(_ tracks: [APITrack])
    func saveConferenceDays(_ conferenceDays: [APIConferenceDay])
    func saveFavouriteEventIdentifier(_ identifier: EventIdentifier)
    func saveDealers(_ dealers: [APIDealer])
    func saveMaps(_ maps: [APIMap])
    func saveReadAnnouncements(_ announcements: [AnnouncementIdentifier])
    func saveImages(_ images: [APIImage])

    func deleteFavouriteEventIdentifier(_ identifier: EventIdentifier)
    func deleteKnowledgeGroup(identifier: String)
    func deleteKnowledgeEntry(identifier: String)
    func deleteAnnouncement(identifier: String)
    func deleteEvent(identifier: String)
    func deleteTrack(identifier: String)
    func deleteRoom(identifier: String)
    func deleteConferenceDay(identifier: String)
    func deleteDealer(identifier: String)
    func deleteMap(identifier: String)
    func deleteImage(identifier: String)

}
