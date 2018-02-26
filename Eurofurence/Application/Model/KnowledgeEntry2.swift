//
//  KnowledgeEntry2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct KnowledgeEntry2: Equatable {

    var title: String

    static func ==(lhs: KnowledgeEntry2, rhs: KnowledgeEntry2) -> Bool {
        return lhs.title == rhs.title
    }

}
