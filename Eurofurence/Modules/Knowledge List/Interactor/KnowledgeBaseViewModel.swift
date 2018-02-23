//
//  KnowledgeListViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIImage

struct KnowledgeListViewModel {

    var knowledgeGroups: [KnowledgeGroupViewModel]

}

struct KnowledgeGroupViewModel {

    var title: String
    var icon: UIImage
    var groupDescription: String
    var knowledgeEntries: [KnowledgeEntryViewModel]

}

struct KnowledgeEntryViewModel: Equatable {

    var title: String

    static func ==(lhs: KnowledgeEntryViewModel, rhs: KnowledgeEntryViewModel) -> Bool {
        return lhs.title == rhs.title
    }

}
