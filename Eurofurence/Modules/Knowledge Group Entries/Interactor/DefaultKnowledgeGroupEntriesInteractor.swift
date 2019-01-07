//
//  DefaultKnowledgeGroupEntriesInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

struct DefaultKnowledgeGroupEntriesInteractor: KnowledgeGroupEntriesInteractor {

    private struct ViewModel: KnowledgeGroupEntriesViewModel {

        var title: String
        var entries: [KnowledgeEntry]

        var numberOfEntries: Int { return entries.count }

        func knowledgeEntry(at index: Int) -> KnowledgeListEntryViewModel {
            let entry = entries[index]
            return KnowledgeListEntryViewModel(title: entry.title)
        }

        func identifierForKnowledgeEntry(at index: Int) -> KnowledgeEntryIdentifier {
            return entries[index].identifier
        }

    }

    var service: KnowledgeService = SharedModel.instance.session

    func makeViewModelForGroup(identifier: KnowledgeGroupIdentifier, completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void) {
        service.fetchKnowledgeGroup(identifier: identifier) { (group) in
            let viewModel = ViewModel(title: group.title, entries: group.entries)
            completionHandler(viewModel)
        }
    }

}
