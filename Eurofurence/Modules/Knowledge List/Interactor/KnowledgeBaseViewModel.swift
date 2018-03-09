//
//  KnowledgeListViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIImage

struct KnowledgeListViewModel: Equatable {

    var knowledgeGroups: [KnowledgeListGroupViewModel]

    static func ==(lhs: KnowledgeListViewModel, rhs: KnowledgeListViewModel) -> Bool {
        return lhs.knowledgeGroups == rhs.knowledgeGroups
    }

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

    static func ==(lhs: KnowledgeListEntryViewModel, rhs: KnowledgeListEntryViewModel) -> Bool {
        return lhs.title == rhs.title
    }

}
