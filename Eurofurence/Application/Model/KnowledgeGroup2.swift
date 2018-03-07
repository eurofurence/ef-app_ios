//
//  KnowledgeGroup2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct KnowledgeGroup2: Comparable, Equatable {

    var title: String
    var groupDescription: String
    var order: Int
    var entries: [KnowledgeEntry2]

    static func <(lhs: KnowledgeGroup2, rhs: KnowledgeGroup2) -> Bool {
        return lhs.order < rhs.order
    }

    static func ==(lhs: KnowledgeGroup2, rhs: KnowledgeGroup2) -> Bool {
        return lhs.title == rhs.title &&
               lhs.groupDescription == rhs.groupDescription &&
               lhs.order == rhs.order &&
               lhs.entries == rhs.entries
    }

}

extension KnowledgeGroup2 {

    static func fromServerModels(groups: [APIKnowledgeGroup], entries: [APIKnowledgeEntry]) -> [KnowledgeGroup2] {
        return groups.map({ (group) -> KnowledgeGroup2 in
            let entries = entries.filter({ $0.groupIdentifier == group.identifier }).map({ (entry) in
                return KnowledgeEntry2(title: entry.title, order: entry.order)
            }).sorted()

            return KnowledgeGroup2(title: group.groupName,
                                   groupDescription: group.groupDescription,
                                   order: group.order,
                                   entries: entries)
        }).sorted()
    }

}
