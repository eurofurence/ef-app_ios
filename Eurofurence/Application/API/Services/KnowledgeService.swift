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

    func fetchKnowledgeEntry(for identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntry2) -> Void)
    func fetchKnowledgeGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping (KnowledgeGroup2) -> Void)
    func fetchImagesForKnowledgeEntry(identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping ([Data]) -> Void)

}

public protocol KnowledgeServiceObserver {

    func knowledgeGroupsDidChange(to groups: [KnowledgeGroup2])

}
