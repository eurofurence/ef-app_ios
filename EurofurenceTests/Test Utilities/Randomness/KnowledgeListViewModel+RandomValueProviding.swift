//
//  KnowledgeListViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Darwin
@testable import Eurofurence
import UIKit.UIImage

extension KnowledgeListViewModel: RandomValueProviding {
    
    static var random: KnowledgeListViewModel {
        var groups = [KnowledgeGroupViewModel]()
        let groupCount = Int.random(upperLimit: 10) + 1
        for _ in 0..<groupCount {
            groups.append(.random)
        }
        
        return KnowledgeListViewModel(knowledgeGroups: groups)
    }
    
    var randomKnowledgeGroup: (index: Int, knowledgeGroup: KnowledgeGroupViewModel) {
        let randomGroupIndex = Int.random(upperLimit: UInt32(knowledgeGroups.count))
        return (index: randomGroupIndex, knowledgeGroup: knowledgeGroups[randomGroupIndex])
    }
    
}

extension KnowledgeGroupViewModel: RandomValueProviding {
    
    static var random: KnowledgeGroupViewModel {
        var entries = [KnowledgeEntryViewModel]()
        let entryCount = Int.random(upperLimit: 10) + 1
        for _ in 0..<entryCount {
            entries.append(.random)
        }
        
        return KnowledgeGroupViewModel(title: .random,
                                       icon: UIImage(),
                                       groupDescription: .random,
                                       knowledgeEntries: entries)
    }
    
    var randomEntry: (index: Int, knowledgeEntry: KnowledgeEntryViewModel) {
        let randomEntryIndex = Int.random(upperLimit: UInt32(knowledgeEntries.count))
        return (index: randomEntryIndex, knowledgeEntry: knowledgeEntries[randomEntryIndex])
    }
    
}

extension KnowledgeEntryViewModel: RandomValueProviding {
    
    static var random: KnowledgeEntryViewModel {
        return KnowledgeEntryViewModel(title: .random)
    }
    
}
