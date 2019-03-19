//
//  KnowledgeGroupCharacteristics+RandomValueProviding.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension KnowledgeGroupCharacteristics: RandomValueProviding {
    
    public static var random: KnowledgeGroupCharacteristics {
        return KnowledgeGroupCharacteristics(identifier: .random,
                                             order: .random,
                                             groupName: .random,
                                             groupDescription: .random,
                                             fontAwesomeCharacterAddress: "\(Int.random(upperLimit: 100))")
    }
    
    static func makeRandomGroupsAndEntries() -> (groups: [KnowledgeGroupCharacteristics], entries: [KnowledgeEntryCharacteristics]) {
        let knowledgeGroups = [KnowledgeGroupCharacteristics].random
        var knowledgeEntries = [KnowledgeEntryCharacteristics]()
        for group in knowledgeGroups {
            let upperLimit = Int.random(upperLimit: 3) + 1
            let range = 0..<upperLimit
            let entries = range.map({ (_) -> KnowledgeEntryCharacteristics in
                var entry = KnowledgeEntryCharacteristics.random
                entry.groupIdentifier = group.identifier
                return entry
            })
            
            knowledgeEntries.append(contentsOf: entries)
        }
        
        return (groups: knowledgeGroups, entries: knowledgeEntries)
    }
    
}
