//
//  EurofurenceDataStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol EurofurenceDataStore {

    func resolveContentsState(completionHandler: @escaping (EurofurenceDataStoreContentsState) -> Void)
    func performTransaction(_ block: @escaping (EurofurenceDataStoreTransaction) -> Void)

    func getLastRefreshDate() -> Date?
    func fetchKnowledgeGroups(completionHandler: ([APIKnowledgeGroup]?) -> Void)
    func fetchKnowledgeEntries(completionHandler: ([APIKnowledgeEntry]?) -> Void)
    func getSavedRooms() -> [APIRoom]?
    func getSavedTracks() -> [APITrack]?
    func getSavedEvents() -> [APIEvent]?

}

protocol EurofurenceDataStoreTransaction {

    func saveLastRefreshDate(_ lastRefreshDate: Date)
    func saveKnowledgeGroups(_ knowledgeGroups: [APIKnowledgeGroup])
    func saveKnowledgeEntries(_ knowledgeEntries: [APIKnowledgeEntry])
    func saveAnnouncements(_ announcements: [APIAnnouncement])
    func saveEvents(_ events: [APIEvent])
    func saveRooms(_ rooms: [APIRoom])
    func saveTracks(_ tracks: [APITrack])

}

enum EurofurenceDataStoreContentsState {
    case empty
    case present
}
