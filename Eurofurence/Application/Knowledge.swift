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
            knowledge.updateKnowledge(groups: response.knowledgeGroups.changed, entries: response.knowledgeEntries.changed)
        }

    }

    // MARK: Properties

    private var models = [KnowledgeGroup2]()

    // MARK: Initialization

    init(eventBus: EventBus) {
        eventBus.subscribe(consumer: KnowledgeUpdater(knowledge: self))
    }

    // MARK: Functions

    func fetchKnowledgeGroups(completionHandler: @escaping ([KnowledgeGroup2]) -> Void) {
        completionHandler(models)
    }

    // MARK: Private

    private func updateKnowledge(groups: [APIKnowledgeGroup],
                                 entries: [APIKnowledgeEntry]) {
        models = KnowledgeGroup2.fromServerModels(groups: groups, entries: entries)
    }

}
