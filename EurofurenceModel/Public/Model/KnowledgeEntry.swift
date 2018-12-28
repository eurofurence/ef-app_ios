//
//  KnowledgeEntry.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

public struct KnowledgeEntry: Comparable, Equatable {

    public struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        public typealias RawValue = String

        public init(_ value: String) {
            self.rawValue = value
        }

        public init?(rawValue: String) {
            self.rawValue = rawValue
        }

        public var rawValue: String

        public static func < (lhs: KnowledgeEntry.Identifier, rhs: KnowledgeEntry.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    public var identifier: KnowledgeEntry.Identifier
    public var title: String
    public var order: Int
    public var contents: String
    public var links: [Link]

    public init(identifier: KnowledgeEntry.Identifier, title: String, order: Int, contents: String, links: [Link]) {
        self.identifier = identifier
        self.title = title
        self.order = order
        self.contents = contents
        self.links = links
    }

    public static func <(lhs: KnowledgeEntry, rhs: KnowledgeEntry) -> Bool {
        return lhs.order < rhs.order
    }

}

public extension KnowledgeEntry {

    public static func fromServerModel(_ entry: APIKnowledgeEntry) -> KnowledgeEntry {
        return KnowledgeEntry(identifier: KnowledgeEntry.Identifier(entry.identifier),
                               title: entry.title,
                               order: entry.order,
                               contents: entry.text,
                               links: Link.fromServerModels(entry.links).sorted())
    }

}
