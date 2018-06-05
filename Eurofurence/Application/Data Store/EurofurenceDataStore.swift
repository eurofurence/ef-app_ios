//
//  EurofurenceDataStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol EurofurenceDataStore {

    func resolveContentsState(completionHandler: @escaping (EurofurenceDataStoreContentsState) -> Void)
    func performTransaction(_ block: @escaping (EurofurenceDataStoreTransaction) -> Void)

    func fetchKnowledgeGroups(completionHandler: ([APIKnowledgeGroup]?) -> Void)
    func fetchKnowledgeEntries(completionHandler: ([APIKnowledgeEntry]?) -> Void)

}

protocol EurofurenceDataStoreTransaction {

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
