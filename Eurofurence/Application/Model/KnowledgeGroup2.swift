//
//  KnowledgeGroup2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct KnowledgeGroup2: Comparable, Equatable {

    struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        typealias RawValue = String

        init(_ value: String) {
            self.rawValue = value
        }

        init?(rawValue: String) {
            self.rawValue = rawValue
        }

        var rawValue: String

        static func < (lhs: KnowledgeGroup2.Identifier, rhs: KnowledgeGroup2.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    var title: String
    var groupDescription: String
    var order: Int
    var entries: [KnowledgeEntry2]

    static func <(lhs: KnowledgeGroup2, rhs: KnowledgeGroup2) -> Bool {
        return lhs.order < rhs.order
    }

}

extension KnowledgeGroup2 {

    static func fromServerModels(groups: [APIKnowledgeGroup], entries: [APIKnowledgeEntry]) -> [KnowledgeGroup2] {
        return groups.map({ (group) -> KnowledgeGroup2 in
            let entries = entries.filter({ $0.groupIdentifier == group.identifier }).map(KnowledgeEntry2.fromServerModel).sorted()

            return KnowledgeGroup2(title: group.groupName,
                                   groupDescription: group.groupDescription,
                                   order: group.order,
                                   entries: entries)
        }).sorted()
    }

}
