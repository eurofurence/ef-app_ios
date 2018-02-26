//
//  APISyncResponse+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

extension APISyncResponse: RandomValueProviding {
    
    static var random: APISyncResponse {
        let knowledgeGroups: [APIKnowledgeGroup] = .random
        var knowledgeEntries = [APIKnowledgeEntry]()
        for group in knowledgeGroups {
            let upperLimit = Int.random(upperLimit: 10) + 1
            let range = 0..<upperLimit
            let entries = range.map({ (_) -> APIKnowledgeEntry in
                var entry = APIKnowledgeEntry.random
                entry.groupIdentifier = group.identifier
                return entry
            })
            
            knowledgeEntries.append(contentsOf: entries)
        }
        
        return APISyncResponse(knowledgeGroups: knowledgeGroups, knowledgeEntries: knowledgeEntries)
    }
    
}

extension APIKnowledgeGroup: RandomValueProviding {
    
    static var random: APIKnowledgeGroup {
        return APIKnowledgeGroup(identifier: .random, groupName: .random, groupDescription: .random)
    }
    
}

extension APIKnowledgeEntry: RandomValueProviding {
    
    static var random: APIKnowledgeEntry {
        return APIKnowledgeEntry(groupIdentifier: .random, title: .random)
    }
    
}
