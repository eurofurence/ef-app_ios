//
//  EurofurenceDataStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol EurofurenceDataStore {

    func performTransaction(_ block: @escaping (EurofurenceDataStoreTransaction) -> Void)

    func getLastRefreshDate() -> Date?
    func getSavedKnowledgeGroups() -> [APIKnowledgeGroup]?
    func getSavedKnowledgeEntries() -> [APIKnowledgeEntry]?
    func getSavedRooms() -> [APIRoom]?
    func getSavedTracks() -> [APITrack]?
    func getSavedEvents() -> [APIEvent]?
    func getSavedAnnouncements() -> [APIAnnouncement]?
    func getSavedConferenceDays() -> [APIConferenceDay]?
    func getSavedFavouriteEventIdentifiers() -> [Event2.Identifier]?
    func getSavedDealers() -> [APIDealer]?
    func getSavedMaps() -> [APIMap]?
    func getSavedReadAnnouncementIdentifiers() -> [Announcement2.Identifier]?
    func getSavedImages() -> [APIImage]?

}

protocol EurofurenceDataStoreTransaction {

    func saveLastRefreshDate(_ lastRefreshDate: Date)
    func saveKnowledgeGroups(_ knowledgeGroups: [APIKnowledgeGroup])
    func saveKnowledgeEntries(_ knowledgeEntries: [APIKnowledgeEntry])
    func saveAnnouncements(_ announcements: [APIAnnouncement])
    func saveEvents(_ events: [APIEvent])
    func saveRooms(_ rooms: [APIRoom])
    func saveTracks(_ tracks: [APITrack])
    func saveConferenceDays(_ conferenceDays: [APIConferenceDay])
    func saveFavouriteEventIdentifier(_ identifier: Event2.Identifier)
    func saveDealers(_ dealers: [APIDealer])
    func saveMaps(_ maps: [APIMap])
    func saveReadAnnouncements(_ announcements: [Announcement2.Identifier])
    func saveImages(_ images: [APIImage])

    func deleteFavouriteEventIdentifier(_ identifier: Event2.Identifier)
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
