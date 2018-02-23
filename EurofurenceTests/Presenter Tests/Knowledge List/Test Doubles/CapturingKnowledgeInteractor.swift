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
    fileprivate var completionHandler: ((KnowledgeListViewModel) -> Void)?
    func prepareViewModel(completionHandler: @escaping (KnowledgeListViewModel) -> Void) {
        toldToPrepareViewModel = true
        self.completionHandler = completionHandler
    }
    
}

extension CapturingKnowledgeInteractor {
    
    func simulateViewModelPrepared(_ viewModel: KnowledgeListViewModel) {
        completionHandler?(viewModel)
    }
    
}
