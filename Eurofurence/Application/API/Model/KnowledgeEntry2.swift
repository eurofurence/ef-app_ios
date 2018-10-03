//
//  KnowledgeEntry2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct KnowledgeEntry2: Comparable, Equatable {

    struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        typealias RawValue = String

        init(_ value: String) {
            self.rawValue = value
        }

        init?(rawValue: String) {
            self.rawValue = rawValue
        }

        var rawValue: String

        static func < (lhs: KnowledgeEntry2.Identifier, rhs: KnowledgeEntry2.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    var identifier: KnowledgeEntry2.Identifier
    var title: String
    var order: Int
    var contents: String
    var links: [Link]

    static func <(lhs: KnowledgeEntry2, rhs: KnowledgeEntry2) -> Bool {
        return lhs.order < rhs.order
    }

}

extension KnowledgeEntry2 {

    static func fromServerModel(_ entry: APIKnowledgeEntry) -> KnowledgeEntry2 {
        return KnowledgeEntry2(identifier: KnowledgeEntry2.Identifier(entry.identifier),
                               title: entry.title,
                               order: entry.order,
                               contents: entry.text,
                               links: Link.fromServerModels(entry.links).sorted())
    }

}
