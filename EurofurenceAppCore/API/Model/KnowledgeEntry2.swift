//
//  KnowledgeEntry2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

public struct KnowledgeEntry2: Comparable, Equatable {

    public struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        public typealias RawValue = String

        public init(_ value: String) {
            self.rawValue = value
        }

        public init?(rawValue: String) {
            self.rawValue = rawValue
        }

        public var rawValue: String

        public static func < (lhs: KnowledgeEntry2.Identifier, rhs: KnowledgeEntry2.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    public var identifier: KnowledgeEntry2.Identifier
    public var title: String
    public var order: Int
    public var contents: String
    public var links: [Link]

    public init(identifier: KnowledgeEntry2.Identifier, title: String, order: Int, contents: String, links: [Link]) {
        self.identifier = identifier
        self.title = title
        self.order = order
        self.contents = contents
        self.links = links
    }

    public static func <(lhs: KnowledgeEntry2, rhs: KnowledgeEntry2) -> Bool {
        return lhs.order < rhs.order
    }

}

public extension KnowledgeEntry2 {

    public static func fromServerModel(_ entry: APIKnowledgeEntry) -> KnowledgeEntry2 {
        return KnowledgeEntry2(identifier: KnowledgeEntry2.Identifier(entry.identifier),
                               title: entry.title,
                               order: entry.order,
                               contents: entry.text,
                               links: Link.fromServerModels(entry.links).sorted())
    }

}
