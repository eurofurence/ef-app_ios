//
//  StubKnowledgeBaseViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Darwin
@testable import Eurofurence
import UIKit.UIImage

struct StubKnowledgeBaseViewModel: KnowledgeBaseViewModel {
    
    static func withRandomData() -> StubKnowledgeBaseViewModel {
        var groups = [StubKnowledgeGroupViewModel]()
        let groupCount = Int(arc4random_uniform(10)) + 1
        for _ in 0..<groupCount {
            groups.append(.withRandomData())
        }
        
        return StubKnowledgeBaseViewModel(groups: groups)
    }
    
    var randomKnowledgeGroup: (index: Int, knowledgeGroup: StubKnowledgeGroupViewModel) {
        let randomGroupIndex = Int(arc4random_uniform(UInt32(knowledgeGroups.count)))
        return (index: randomGroupIndex, knowledgeGroup: groups[randomGroupIndex])
    }
    
    var groups = [StubKnowledgeGroupViewModel]()
    var knowledgeGroups: [KnowledgeGroupViewModel] { return groups }
    
}

struct StubKnowledgeGroupViewModel: KnowledgeGroupViewModel {
    
    static func withRandomData() -> StubKnowledgeGroupViewModel {
        var entries = [StubKnowledgeEntryViewModel]()
        let entryCount = Int(arc4random_uniform(10)) + 1
        for _ in 0..<entryCount {
            entries.append(.withRandomData())
        }
        
        return StubKnowledgeGroupViewModel(entries: entries,
                                           title: "\(arc4random())",
                                           icon: UIImage(),
                                           groupDescription: "\(arc4random())")
    }
    
    var randomEntry: (index: Int, knowledgeEntry: StubKnowledgeEntryViewModel) {
        let randomEntryIndex = Int(arc4random_uniform(UInt32(knowledgeEntries.count)))
        return (index: randomEntryIndex, knowledgeEntry: entries[randomEntryIndex])
    }
    
    var entries = [StubKnowledgeEntryViewModel]()
    var knowledgeEntries: [KnowledgeEntryViewModel] { return entries }
    
    var title: String
    var icon: UIImage
    var groupDescription: String
    
}

struct StubKnowledgeEntryViewModel: KnowledgeEntryViewModel, Equatable {
    
    static func ==(lhs: StubKnowledgeEntryViewModel, rhs: StubKnowledgeEntryViewModel) -> Bool {
        return lhs.title == rhs.title
    }
    
    static func withRandomData() -> StubKnowledgeEntryViewModel {
        return StubKnowledgeEntryViewModel(title: "\(arc4random())")
    }
    
    var title: String
    
}
