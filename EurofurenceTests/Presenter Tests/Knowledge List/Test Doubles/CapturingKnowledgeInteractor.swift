//
//  CapturingKnowledgeInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingKnowledgeInteractor: KnowledgeInteractor {
    
    private(set) var toldToPrepareViewModel = false
    func prepareViewModel() {
        toldToPrepareViewModel = true
    }
    
}
