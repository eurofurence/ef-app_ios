//
//  KnowledgeGroupEntriesPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import UIKit

class KnowledgeGroupEntriesPresenterTestBuilder {
    
    struct Context {
        var viewController: UIViewController
        var viewModel: StubKnowledgeGroupEntriesViewModel
        var sceneFactory: StubKnowledgeGroupEntriesSceneFactory
        var delegate: CapturingKnowledgeGroupEntriesModuleDelegate
    }
    
    func build() -> Context {
        let viewModel = StubKnowledgeGroupEntriesViewModel.random
        let groupIdentifier = KnowledgeGroup2.Identifier.random
        let interactor = FakeKnowledgeGroupEntriesInteractor(for: groupIdentifier, viewModel: viewModel)
        let sceneFactory = StubKnowledgeGroupEntriesSceneFactory()
        let delegate = CapturingKnowledgeGroupEntriesModuleDelegate()
        let module = KnowledgeGroupEntriesModuleBuilder()
            .with(interactor)
            .with(sceneFactory)
            .build()
            .makeKnowledgeGroupEntriesModule(groupIdentifier, delegate: delegate)
        
        return Context(viewController: module,
                       viewModel: viewModel,
                       sceneFactory: sceneFactory,
                       delegate: delegate)
    }
    
}

extension KnowledgeGroupEntriesPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        sceneFactory.scene.simulateSceneDidLoad()
    }
    
    func simulateSceneDidSelectEntry(at index: Int) {
        sceneFactory.scene.simulateSceneDidSelectEntry(at: index)
    }
    
    func bind(_ component: CapturingKnowledgeGroupEntryScene, at index: Int) {
        sceneFactory.scene.binder?.bind(component, at: index)
    }
    
}
