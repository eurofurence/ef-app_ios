//
//  KnowledgeGroupsListViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit.UIImage

protocol KnowledgeGroupsListViewModel {

    func setDelegate(_ delegate: KnowledgeGroupsListViewModelDelegate)
    func fetchIdentifierForGroup(at index: Int, completionHandler: @escaping (KnowledgeGroup.Identifier) -> Void)

}

protocol KnowledgeGroupsListViewModelDelegate {

    func knowledgeGroupsViewModelsDidUpdate(to viewModels: [KnowledgeListGroupViewModel])

}

struct KnowledgeListGroupViewModel: Equatable {

    var title: String
    var fontAwesomeCharacter: Character
    var groupDescription: String
    var knowledgeEntries: [KnowledgeListEntryViewModel]

}

struct KnowledgeListEntryViewModel: Equatable {

    var title: String

}
