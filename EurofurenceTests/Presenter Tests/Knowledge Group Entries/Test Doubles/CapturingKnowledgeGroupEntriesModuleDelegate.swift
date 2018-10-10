//
//  CapturingKnowledgeGroupEntriesModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import Foundation

class CapturingKnowledgeGroupEntriesModuleDelegate: KnowledgeGroupEntriesModuleDelegate {
    
    private(set) var selectedKnowledgeEntryIdentifier: KnowledgeEntry2.Identifier?
    func knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: KnowledgeEntry2.Identifier) {
        selectedKnowledgeEntryIdentifier = identifier
    }
    
}
