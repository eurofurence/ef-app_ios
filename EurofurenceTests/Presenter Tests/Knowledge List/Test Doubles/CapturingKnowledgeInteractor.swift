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
    fileprivate var completionHandler: ((KnowledgeBaseViewModel) -> Void)?
    func prepareViewModel(completionHandler: @escaping (KnowledgeBaseViewModel) -> Void) {
        toldToPrepareViewModel = true
        self.completionHandler = completionHandler
    }
    
}

extension CapturingKnowledgeInteractor {
    
    func simulateViewModelPrepared(_ viewModel: KnowledgeBaseViewModel) {
        completionHandler?(viewModel)
    }
    
}
