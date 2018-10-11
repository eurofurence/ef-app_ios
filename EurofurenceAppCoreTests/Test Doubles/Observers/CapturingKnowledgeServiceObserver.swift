//
//  CapturingKnowledgeServiceObserver.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class CapturingKnowledgeServiceObserver: KnowledgeServiceObserver {

    private(set) var capturedGroups: [KnowledgeGroup] = []
    private(set) var wasProvidedWithEmptyGroups = false
    func knowledgeGroupsDidChange(to groups: [KnowledgeGroup]) {
        wasProvidedWithEmptyGroups = wasProvidedWithEmptyGroups || groups.isEmpty
        capturedGroups = groups
    }

}
