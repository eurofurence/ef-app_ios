//
//  CapturingKnowledgeGroupsInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation.NSIndexPath

class CapturingKnowledgeGroupsInteractor: KnowledgeGroupsInteractor {
    
    var prepareViewModelInvokedHandler: (() -> Void)?
    private(set) var toldToPrepareViewModel = false
    fileprivate var completionHandler: ((KnowledgeGroupsListViewModel) -> Void)?
    func prepareViewModel(completionHandler: @escaping (KnowledgeGroupsListViewModel) -> Void) {
        toldToPrepareViewModel = true
        self.completionHandler = completionHandler
        prepareViewModelInvokedHandler?()
    }
    
}

extension CapturingKnowledgeGroupsInteractor {
    
    func simulateViewModelPrepared(_ viewModel: KnowledgeGroupsListViewModel) {
        completionHandler?(viewModel)
    }
    
}
