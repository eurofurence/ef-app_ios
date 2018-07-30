//
//  CapturingKnowledgeGroupEntriesScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingKnowledgeGroupEntriesScene: KnowledgeGroupEntriesScene {
    
    fileprivate var delegate: KnowledgeGroupEntriesSceneDelegate?
    func setDelegate(_ delegate: KnowledgeGroupEntriesSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedNumberOfEntriesToBind: Int?
    func bind(numberOfEntries: Int) {
        capturedNumberOfEntriesToBind = numberOfEntries
    }
    
}

extension CapturingKnowledgeGroupEntriesScene {
    
    func simulateSceneDidLoad() {
        delegate?.knowledgeGroupEntriesSceneDidLoad()
    }
    
}
