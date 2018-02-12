//
//  StubKnowledgeBaseViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Darwin
@testable import Eurofurence

struct StubKnowledgeBaseViewModel: KnowledgeBaseViewModel {
    
    static func withRandomData() -> StubKnowledgeBaseViewModel {
        var groups = [StubKnowledgeGroupViewModel]()
        let groupCount = Int(arc4random_uniform(10)) + 1
        for _ in 0..<groupCount {
            groups.append(.withRandomData())
        }
        
        return StubKnowledgeBaseViewModel(groups: groups)
    }
    
    var groups = [StubKnowledgeGroupViewModel]()
    var knowledgeGroups: [KnowledgeGroupViewModel] { return groups }
    
}

struct StubKnowledgeGroupViewModel: KnowledgeGroupViewModel {
    
    static func withRandomData() -> StubKnowledgeGroupViewModel {
        var entries = [StubKnowledgeEntryViewModel]()
        let entryCount = Int(arc4random_uniform(10))
        for _ in 0..<entryCount {
            entries.append(.withRandomData())
        }
        
        return StubKnowledgeGroupViewModel(entries: entries)
    }
    
    var entries = [StubKnowledgeEntryViewModel]()
    var knowledgeEntries: [KnowledgeEntryViewModel] { return entries }
    
}

struct StubKnowledgeEntryViewModel: KnowledgeEntryViewModel {
    
    static func withRandomData() -> StubKnowledgeEntryViewModel {
        return StubKnowledgeEntryViewModel()
    }
    
}
