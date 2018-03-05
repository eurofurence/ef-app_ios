//
//  APIKnowledgeEntry.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APIKnowledgeEntry: Equatable {

    var groupIdentifier: String
    var title: String

    static func ==(lhs: APIKnowledgeEntry, rhs: APIKnowledgeEntry) -> Bool {
        return lhs.groupIdentifier == rhs.groupIdentifier && lhs.title == rhs.title
    }

}
