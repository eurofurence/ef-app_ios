//
//  StubKnowledgeGroupsListViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct StubKnowledgeGroupsListViewModel: KnowledgeGroupsListViewModel {
    
    var knowledgeGroups: [KnowledgeListGroupViewModel]
    
}

extension StubKnowledgeGroupsListViewModel: RandomValueProviding {
    
    static var random: StubKnowledgeGroupsListViewModel {
        return StubKnowledgeGroupsListViewModel(knowledgeGroups: .random)
    }
    
}
