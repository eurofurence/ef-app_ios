//
//  KnowledgeListPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class KnowledgeListPresenterTestBuilder {
    
    struct Context {
        var knowledgeInteractor: CapturingKnowledgeInteractor
        var scene: CapturingKnowledgeListScene
        var delegate: CapturingKnowledgeListModuleDelegate
    }
    
    func build() -> Context {
        let knowledgeInteractor = CapturingKnowledgeInteractor()
        let sceneFactory = StubKnowledgeListSceneFactory()
        let delegate = CapturingKnowledgeListModuleDelegate()
        _ = KnowledgeListModuleBuilder()
            .with(knowledgeInteractor)
            .with(sceneFactory)
            .build()
            .makeKnowledgeListModule(delegate)
        
        return Context(knowledgeInteractor: knowledgeInteractor,
                       scene: sceneFactory.scene,
                       delegate: delegate)
    }
    
}

extension KnowledgeListPresenterTestBuilder.Context {
    
    func simulateLoadingViewModel(_ viewModel: KnowledgeBaseViewModel = StubKnowledgeBaseViewModel()) {
        knowledgeInteractor.simulateViewModelPrepared(viewModel)
    }
    
}
