//
//  DefaultKnowledgeGroupsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIImage

struct DefaultKnowledgeGroupsInteractor: KnowledgeGroupsInteractor {

    private struct ViewModel: KnowledgeGroupsListViewModel {

        var knowledgeGroups: [KnowledgeListGroupViewModel]

        func fetchIdentifierForGroup(at index: Int, completionHandler: @escaping (KnowledgeGroup2.Identifier) -> Void) {

        }

    }

    var service: KnowledgeService

    func prepareViewModel(completionHandler: @escaping (KnowledgeGroupsListViewModel) -> Void) {
        service.fetchKnowledgeGroups { (groups) in
            let viewModel = ViewModel(knowledgeGroups: groups.map(self.knowledgeGroupViewModel))
            completionHandler(viewModel)
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
