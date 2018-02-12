//
//  KnowledgeBaseViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol KnowledgeBaseViewModel {

    var knowledgeGroups: [KnowledgeGroupViewModel] { get }

}

protocol KnowledgeGroupViewModel {

    var knowledgeEntries: [KnowledgeEntryViewModel] { get }

}

protocol KnowledgeEntryViewModel {

}
