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
    var icon: UIImage
    var groupDescription: String
    var knowledgeEntries: [KnowledgeListEntryViewModel]

    static func ==(lhs: KnowledgeListGroupViewModel, rhs: KnowledgeListGroupViewModel) -> Bool {
        return lhs.title == rhs.title &&
//               lhs.icon == rhs.icon &&
               lhs.groupDescription == rhs.groupDescription &&
               lhs.knowledgeEntries == rhs.knowledgeEntries
    }

}

struct KnowledgeListEntryViewModel: Equatable {

    var title: String

}
