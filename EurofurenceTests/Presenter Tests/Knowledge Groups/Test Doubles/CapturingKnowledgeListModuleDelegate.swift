//
//  CapturingKnowledgeGroupsListModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles

class CapturingKnowledgeGroupsListModuleDelegate: KnowledgeGroupsListModuleDelegate {

    private(set) var capturedKnowledgeGroupToPresent: KnowledgeGroup.Identifier?
    func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroup.Identifier) {
        capturedKnowledgeGroupToPresent = knowledgeGroup
    }

}
