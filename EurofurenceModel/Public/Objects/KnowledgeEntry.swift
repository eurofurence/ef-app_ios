//
//  KnowledgeEntry.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

public typealias KnowledgeEntryIdentifier = Identifier<KnowledgeEntry>

public struct KnowledgeEntry: Comparable, Equatable {

    public var identifier: KnowledgeEntryIdentifier
    public var title: String
    public var order: Int
    public var contents: String
    public var links: [Link]

    public init(identifier: KnowledgeEntryIdentifier, title: String, order: Int, contents: String, links: [Link]) {
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

    public static func fromServerModel(_ entry: KnowledgeEntryCharacteristics) -> KnowledgeEntry {
        return KnowledgeEntry(identifier: KnowledgeEntryIdentifier(entry.identifier),
                               title: entry.title,
                               order: entry.order,
                               contents: entry.text,
                               links: Link.fromServerModels(entry.links).sorted())
    }

}
