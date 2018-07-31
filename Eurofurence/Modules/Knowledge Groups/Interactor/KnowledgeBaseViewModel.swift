//
//  KnowledgeGroupsListViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIImage

protocol KnowledgeGroupsListViewModel {

    var knowledgeGroups: [KnowledgeListGroupViewModel] { get }

    func fetchIdentifierForGroup(at index: Int, completionHandler: @escaping (KnowledgeGroup2.Identifier) -> Void)

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
