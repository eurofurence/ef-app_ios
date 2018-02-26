//
//  KnowledgeGroup2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct KnowledgeGroup2: Equatable {

    var title: String
    var groupDescription: String
    var entries: [KnowledgeEntry2]

    static func ==(lhs: KnowledgeGroup2, rhs: KnowledgeGroup2) -> Bool {
        return lhs.title == rhs.title &&
               lhs.groupDescription == rhs.groupDescription &&
               lhs.entries == rhs.entries
    }

}
