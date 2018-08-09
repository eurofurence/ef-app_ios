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
    
    fileprivate var capturedFetchCompletionHandler: (([KnowledgeGroup2]) -> Void)?
    func fetchKnowledgeGroups(completionHandler: @escaping ([KnowledgeGroup2]) -> Void) {
        capturedFetchCompletionHandler = completionHandler
    }
    
    func fetchKnowledgeEntry(for identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntry2) -> Void) {
        
    }
    
    func fetchKnowledgeEntriesForGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping ([KnowledgeEntry2]) -> Void) {
        
    }
    
    func fetchImagesForKnowledgeEntry(identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping ([Data]) -> Void) {
        
    }
    
}

extension StubKnowledgeService {
    
    func simulateFetchSucceeded(_ models: [KnowledgeGroup2]) {
        capturedFetchCompletionHandler?(models)
    }
    
}
