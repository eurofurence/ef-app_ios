//
//  StubKnowledgeService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubKnowledgeService: KnowledgeService {
    
    func fetchKnowledgeGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping (KnowledgeGroup2) -> Void) {
        
    }
    
    fileprivate var observers: [KnowledgeServiceObserver] = []
    func add(_ observer: KnowledgeServiceObserver) {
        observers.append(observer)
    }
    
    func fetchKnowledgeEntry(for identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntry2) -> Void) {
        
    }
    
    func fetchKnowledgeGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping ([KnowledgeEntry2]) -> Void) {
        
    }
    
    func fetchImagesForKnowledgeEntry(identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping ([Data]) -> Void) {
        
    }
    
}

extension StubKnowledgeService {
    
    func simulateFetchSucceeded(_ models: [KnowledgeGroup2]) {
        observers.forEach { $0.knowledgeGroupsDidChange(to: models) }
    }
    
}
