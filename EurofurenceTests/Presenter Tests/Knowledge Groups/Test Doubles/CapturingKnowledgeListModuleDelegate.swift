//
//  CapturingKnowledgeGroupsListModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingKnowledgeGroupsListModuleDelegate: KnowledgeGroupsListModuleDelegate {
    
    private(set) var capturedKnowledgeGroupToPresent: KnowledgeGroup2.Identifier?
    func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroup2.Identifier) {
        capturedKnowledgeGroupToPresent = knowledgeGroup
    }
    
}
