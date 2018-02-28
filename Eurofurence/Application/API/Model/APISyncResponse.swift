//
//  APISyncResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APISyncDelta<T> {

    var changed: [T]
    var deleted: [T]

    init(changed: [T] = [], deleted: [T] = []) {
        self.changed = changed
        self.deleted = deleted
    }

}

struct APISyncResponse {

    var knowledgeGroups: APISyncDelta<APIKnowledgeGroup>
    var knowledgeEntries: APISyncDelta<APIKnowledgeEntry>

}
