//
//  KnowledgeService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol KnowledgeService {

    func add(_ observer: KnowledgeServiceObserver)

    func fetchKnowledgeEntry(for identifier: KnowledgeEntryIdentifier, completionHandler: @escaping (KnowledgeEntry) -> Void)
    func fetchKnowledgeGroup(identifier: KnowledgeGroupIdentifier, completionHandler: @escaping (KnowledgeGroup) -> Void)
    func fetchImagesForKnowledgeEntry(identifier: KnowledgeEntryIdentifier, completionHandler: @escaping ([Data]) -> Void)

}

public protocol KnowledgeServiceObserver {

    func knowledgeGroupsDidChange(to groups: [KnowledgeGroup])

}
