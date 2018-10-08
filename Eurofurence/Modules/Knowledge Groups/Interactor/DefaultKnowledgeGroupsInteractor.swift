//
//  DefaultKnowledgeGroupsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import UIKit.UIImage

struct DefaultKnowledgeGroupsInteractor: KnowledgeGroupsInteractor {

    private class ViewModel: KnowledgeGroupsListViewModel, KnowledgeServiceObserver {

        private var groups = [KnowledgeGroup2]()
        private var knowledgeGroups: [KnowledgeListGroupViewModel] = []
        private var delegate: KnowledgeGroupsListViewModelDelegate?

        func knowledgeGroupsDidChange(to groups: [KnowledgeGroup2]) {
            self.groups = groups
            knowledgeGroups = groups.map { (group) -> KnowledgeListGroupViewModel in
                let entries = group.entries.map { (entry) -> KnowledgeListEntryViewModel in
                    return KnowledgeListEntryViewModel(title: entry.title)
                }

                return KnowledgeListGroupViewModel(title: group.title,
                                                   fontAwesomeCharacter: group.fontAwesomeCharacterAddress,
                                                   groupDescription: group.groupDescription,
                                                   knowledgeEntries: entries)
            }

            delegate?.knowledgeGroupsViewModelsDidUpdate(to: knowledgeGroups)
        }

        func setDelegate(_ delegate: KnowledgeGroupsListViewModelDelegate) {
            self.delegate = delegate
            delegate.knowledgeGroupsViewModelsDidUpdate(to: knowledgeGroups)
        }

        func fetchIdentifierForGroup(at index: Int, completionHandler: @escaping (KnowledgeGroup2.Identifier) -> Void) {
            completionHandler(groups[index].identifier)
        }

    }

    var service: KnowledgeService

    init(service: KnowledgeService) {
        self.service = service
    }

    func prepareViewModel(completionHandler: @escaping (KnowledgeGroupsListViewModel) -> Void) {
        let viewModel = ViewModel()
        service.add(viewModel)
        completionHandler(viewModel)
    }

}
