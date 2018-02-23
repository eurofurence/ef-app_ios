//
//  KnowledgeListPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class KnowledgeListPresenterTestBuilder {
    
    struct Context {
        var knowledgeInteractor: CapturingKnowledgeInteractor
        var scene: CapturingKnowledgeListScene
        var delegate: CapturingKnowledgeListModuleDelegate
        var producedViewController: UIViewController
    }
    
    func build() -> Context {
        let knowledgeInteractor = CapturingKnowledgeInteractor()
        let sceneFactory = StubKnowledgeListSceneFactory()
        let delegate = CapturingKnowledgeListModuleDelegate()
        let producedViewController = KnowledgeListModuleBuilder()
            .with(knowledgeInteractor)
            .with(sceneFactory)
            .build()
            .makeKnowledgeListModule(delegate)
        
        return Context(knowledgeInteractor: knowledgeInteractor,
                       scene: sceneFactory.scene,
                       delegate: delegate,
                       producedViewController: producedViewController)
    }
    
}

extension KnowledgeListPresenterTestBuilder.Context {
    
    func simulateLoadingViewModel(_ viewModel: KnowledgeListViewModel = .random) {
        knowledgeInteractor.simulateViewModelPrepared(viewModel)
    }
    
}
