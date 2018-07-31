//
//  DefaultKnowledgeGroupEntriesInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultKnowledgeGroupEntriesInteractor: KnowledgeGroupEntriesInteractor {

    private struct ViewModel: KnowledgeGroupEntriesViewModel {

        var entries: [KnowledgeEntry2]

        var numberOfEntries: Int { return entries.count }

        func knowledgeEntry(at index: Int) -> KnowledgeListEntryViewModel {
            let entry = entries[index]
            return KnowledgeListEntryViewModel(title: entry.title)
        }

        func identifierForKnowledgeEntry(at index: Int) -> KnowledgeEntry2.Identifier {
            return KnowledgeEntry2.Identifier("")
        }

    }

    var service: KnowledgeService = EurofurenceApplication.shared

    func makeViewModelForGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void) {
        service.fetchKnowledgeEntriesForGroup(identifier: identifier) { (entries) in
            let viewModel = ViewModel(entries: entries)
            completionHandler(viewModel)
        }
    }

}
