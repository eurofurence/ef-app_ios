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

        private let groups: [KnowledgeGroup2]
        var knowledgeGroups: [KnowledgeListGroupViewModel]

        init(groups: [KnowledgeGroup2]) {
            self.groups = groups
            knowledgeGroups = groups.map { (group) -> KnowledgeListGroupViewModel in
                let entries = group.entries.map { (entry) -> KnowledgeListEntryViewModel in
                    return KnowledgeListEntryViewModel(title: entry.title)
                }

                return KnowledgeListGroupViewModel(title: group.title,
                                                   icon: UIImage(),
                                                   groupDescription: group.groupDescription,
                                                   knowledgeEntries: entries)
            }
        }

        func fetchIdentifierForGroup(at index: Int, completionHandler: @escaping (KnowledgeGroup2.Identifier) -> Void) {
            completionHandler(groups[index].identifier)
        }

    }

    var service: KnowledgeService

    func prepareViewModel(completionHandler: @escaping (KnowledgeGroupsListViewModel) -> Void) {
        service.fetchKnowledgeGroups { (groups) in
            let viewModel = ViewModel(groups: groups)
            completionHandler(viewModel)
        }
    }

}
