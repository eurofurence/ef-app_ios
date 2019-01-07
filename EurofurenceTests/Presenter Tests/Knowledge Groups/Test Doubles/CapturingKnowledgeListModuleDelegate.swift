//
//  CapturingKnowledgeGroupsListModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class CapturingKnowledgeGroupsListModuleDelegate: KnowledgeGroupsListModuleDelegate {

    private(set) var capturedKnowledgeGroupToPresent: KnowledgeGroupIdentifier?
    func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroupIdentifier) {
        capturedKnowledgeGroupToPresent = knowledgeGroup
    }

}
