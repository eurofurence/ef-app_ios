//
//  KnowledgeListViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIImage

struct KnowledgeListViewModel: Equatable {

    var knowledgeGroups: [KnowledgeGroupViewModel]

    static func ==(lhs: KnowledgeListViewModel, rhs: KnowledgeListViewModel) -> Bool {
        return lhs.knowledgeGroups == rhs.knowledgeGroups
    }

}

struct KnowledgeGroupViewModel: Equatable {

    var title: String
    var icon: UIImage
    var groupDescription: String
    var knowledgeEntries: [KnowledgeEntryViewModel]

    static func ==(lhs: KnowledgeGroupViewModel, rhs: KnowledgeGroupViewModel) -> Bool {
        return lhs.title == rhs.title &&
//               lhs.icon == rhs.icon &&
               lhs.groupDescription == rhs.groupDescription &&
               lhs.knowledgeEntries == rhs.knowledgeEntries
    }

}

struct KnowledgeEntryViewModel: Equatable {

    var title: String

    static func ==(lhs: KnowledgeEntryViewModel, rhs: KnowledgeEntryViewModel) -> Bool {
        return lhs.title == rhs.title
    }

}
