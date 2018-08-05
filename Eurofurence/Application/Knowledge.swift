//
//  Knowledge.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class Knowledge {

    // MARK: Properties

    private let dataStore: EurofurenceDataStore
    private var models = [KnowledgeGroup2]()

    // MARK: Initialization

    init(eventBus: EventBus, dataStore: EurofurenceDataStore) {
        self.dataStore = dataStore
        eventBus.subscribe(consumer: DataStoreChangedConsumer(handler: reloadKnowledgeBaseFromDataStore))

        reloadKnowledgeBaseFromDataStore()
    }

    // MARK: Functions

    func fetchKnowledgeGroups(completionHandler: @escaping ([KnowledgeGroup2]) -> Void) {
        completionHandler(models)
    }

    func fetchKnowledgeEntry(for identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntry2) -> Void) {
        models.reduce([], { $0 + $1.entries }).first(where: { $0.identifier == identifier }).let(completionHandler)
    }

    func fetchKnowledgeEntriesForGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping ([KnowledgeEntry2]) -> Void) {
        models.first(where: { $0.identifier == identifier }).let { completionHandler($0.entries) }
    }

    // MARK: Private

    private func reloadKnowledgeBaseFromDataStore() {
        guard let groups = dataStore.getSavedKnowledgeGroups(),
              let entries = dataStore.getSavedKnowledgeEntries() else {
                return
        }

        models = KnowledgeGroup2.fromServerModels(groups: groups, entries: entries)
    }

}
