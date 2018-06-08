//
//  APIKnowledgeEntry.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APIKnowledgeEntry: Comparable, Equatable {

    var groupIdentifier: String
    var title: String
    var order: Int
    var text: String
    var links: [APILink]

    static func <(lhs: APIKnowledgeEntry, rhs: APIKnowledgeEntry) -> Bool {
        return lhs.title < rhs.title
    }

    static func ==(lhs: APIKnowledgeEntry, rhs: APIKnowledgeEntry) -> Bool {
        return lhs.groupIdentifier == rhs.groupIdentifier &&
               lhs.title == rhs.title &&
               lhs.order == rhs.order &&
               lhs.text == rhs.text &&
               lhs.links == rhs.links
    }

}
