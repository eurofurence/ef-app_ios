//
//  DefaultKnowledgeGroupEntriesInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

struct DefaultKnowledgeGroupEntriesInteractor: KnowledgeGroupEntriesInteractor {

    private struct ViewModel: KnowledgeGroupEntriesViewModel {

        var title: String
        var entries: [KnowledgeEntry2]

        var numberOfEntries: Int { return entries.count }

        func knowledgeEntry(at index: Int) -> KnowledgeListEntryViewModel {
            let entry = entries[index]
            return KnowledgeListEntryViewModel(title: entry.title)
        }

        func identifierForKnowledgeEntry(at index: Int) -> KnowledgeEntry2.Identifier {
            return entries[index].identifier
        }

    }

    var service: KnowledgeService = EurofurenceApplication.shared

    func makeViewModelForGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void) {
        service.fetchKnowledgeGroup(identifier: identifier) { (group) in
            let viewModel = ViewModel(title: group.title, entries: group.entries)
            completionHandler(viewModel)
        }
    }

}
