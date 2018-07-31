//
//  KnowledgeGroupEntriesPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class KnowledgeGroupEntriesPresenterTestBuilder {
    
    struct Context {
        var viewModel: StubKnowledgeGroupEntriesViewModel
        var sceneFactory: StubKnowledgeGroupEntriesSceneFactory
    }
    
    func build() -> Context {
        let viewModel = StubKnowledgeGroupEntriesViewModel.random
        let groupIdentifier = KnowledgeGroup2.Identifier.random
        let interactor = FakeKnowledgeGroupEntriesInteractor(for: groupIdentifier, viewModel: viewModel)
        let sceneFactory = StubKnowledgeGroupEntriesSceneFactory()
        _ = KnowledgeGroupEntriesModuleBuilder()
            .with(interactor)
            .with(sceneFactory)
            .build()
            .makeKnowledgeGroupEntriesModule(groupIdentifier)
        
        return Context(viewModel: viewModel, sceneFactory: sceneFactory)
    }
    
}

extension KnowledgeGroupEntriesPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        sceneFactory.scene.simulateSceneDidLoad()
    }
    
}
