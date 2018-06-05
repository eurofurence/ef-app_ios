//
//  KnowledgeEntry2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct KnowledgeEntry2: Comparable, Equatable, Hashable {

    var title: String
    var order: Int
    var contents: String
    var links: [Link]

    var hashValue: Int {
        return title.hashValue ^ order.hashValue ^ contents.hashValue
    }

    static func ==(lhs: KnowledgeEntry2, rhs: KnowledgeEntry2) -> Bool {
        return lhs.title == rhs.title &&
               lhs.order == rhs.order &&
               lhs.contents == rhs.contents &&
               lhs.links == rhs.links
    }

    static func <(lhs: KnowledgeEntry2, rhs: KnowledgeEntry2) -> Bool {
        return lhs.order < rhs.order
    }

}

extension KnowledgeEntry2 {

    static func fromServerModel(_ entry: APIKnowledgeEntry) -> KnowledgeEntry2 {
        return KnowledgeEntry2(title: entry.title,
                               order: entry.order,
                               contents: entry.text,
                               links: Link.fromServerModels(entry.links).sorted())
    }

}
