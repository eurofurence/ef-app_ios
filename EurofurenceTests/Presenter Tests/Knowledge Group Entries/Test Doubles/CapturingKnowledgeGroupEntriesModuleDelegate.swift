//
//  CapturingKnowledgeGroupEntriesModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingKnowledgeGroupEntriesModuleDelegate: KnowledgeGroupEntriesModuleDelegate {

    private(set) var selectedKnowledgeEntryIdentifier: KnowledgeEntry.Identifier?
    func knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: KnowledgeEntry.Identifier) {
        selectedKnowledgeEntryIdentifier = identifier
    }

}
