//
//  DefaultKnowledgeListInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIImage

struct DefaultKnowledgeListInteractor: KnowledgeInteractor {

    var service: KnowledgeService

    func prepareViewModel(completionHandler: @escaping (KnowledgeListViewModel) -> Void) {
        service.fetchKnowledgeGroups { (groups) in
            let viewModel = KnowledgeListViewModel(knowledgeGroups: groups.map(self.knowledgeGroupViewModel))
            completionHandler(viewModel)
        }
    }

    func fetchEntry(inGroup group: Int, index: Int, completionHandler: @escaping (KnowledgeEntry2) -> Void) {
        service.fetchKnowledgeGroups { (groups) in
            let group = groups[group]
            let entry = group.entries[index]
            completionHandler(entry)
        }
    }

    private func knowledgeGroupViewModel(for group: KnowledgeGroup2) -> KnowledgeListGroupViewModel {
        return KnowledgeListGroupViewModel(title: group.title,
                                       icon: UIImage(),
                                       groupDescription: group.groupDescription,
                                       knowledgeEntries: group.entries.map(knowledgeEntryViewModel))
    }

    private func knowledgeEntryViewModel(for entry: KnowledgeEntry2) -> KnowledgeListEntryViewModel {
        return KnowledgeListEntryViewModel(title: entry.title)
    }

}
