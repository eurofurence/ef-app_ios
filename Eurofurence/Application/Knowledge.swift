//
//  Knowledge.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class Knowledge {

    // MARK: Nested Types

    private class KnowledgeUpdater: EventConsumer {

        private let knowledge: Knowledge

        init(knowledge: Knowledge) {
            self.knowledge = knowledge
        }

        func consume(event: DomainEvent.LatestDataFetchedEvent) {
            let response = event.response
            knowledge.updateKnowledge(groups: response.knowledgeGroups, entries: response.knowledgeEntries)
        }

    }

    // MARK: Properties

    private let dataStore: EurofurenceDataStore
    private var models = [KnowledgeGroup2]()

    // MARK: Initialization

    init(eventBus: EventBus, dataStore: EurofurenceDataStore) {
        self.dataStore = dataStore
        eventBus.subscribe(consumer: KnowledgeUpdater(knowledge: self))

        reloadKnowledgeBaseFromDataStore()
    }

    // MARK: Functions

    func fetchKnowledgeGroups(completionHandler: @escaping ([KnowledgeGroup2]) -> Void) {
        completionHandler(models)
    }

    // MARK: Private

    private func reloadKnowledgeBaseFromDataStore() {
        guard let groups = dataStore.getSavedKnowledgeGroups(),
              let entries = dataStore.getSavedKnowledgeEntries() else {
                return
        }

        models = KnowledgeGroup2.fromServerModels(groups: groups, entries: entries)
    }

    private func updateKnowledge(groups: APISyncDelta<APIKnowledgeGroup>,
                                 entries: APISyncDelta<APIKnowledgeEntry>) {
        dataStore.performTransaction { (transaction) in
            entries.deleted.forEach(transaction.deleteKnowledgeEntry)
            groups.deleted.forEach(transaction.deleteKnowledgeGroup)

            transaction.saveKnowledgeGroups(groups.changed)
            transaction.saveKnowledgeEntries(entries.changed)
        }

        reloadKnowledgeBaseFromDataStore()
    }

}
