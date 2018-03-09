//
//  CapturingKnowledgeListModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingKnowledgeListModuleDelegate: KnowledgeListModuleDelegate {
    
    private(set) var capturedKnowledgeEntryToPresent: KnowledgeListEntryViewModel?
    func knowledgeListModuleDidSelectKnowledgeEntry(_ knowledgeEntry: KnowledgeListEntryViewModel) {
        capturedKnowledgeEntryToPresent = knowledgeEntry
    }
    
}
