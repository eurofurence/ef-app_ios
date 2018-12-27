//
//  KnowledgeGroupsPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class KnowledgeGroupsPresenterTestBuilder {

    struct Context {
        var knowledgeInteractor: CapturingKnowledgeGroupsInteractor
        var scene: CapturingKnowledgeListScene
        var delegate: CapturingKnowledgeGroupsListModuleDelegate
        var producedViewController: UIViewController
    }

    func build() -> Context {
        let knowledgeInteractor = CapturingKnowledgeGroupsInteractor()
        let sceneFactory = StubKnowledgeListSceneFactory()
        let delegate = CapturingKnowledgeGroupsListModuleDelegate()
        let producedViewController = KnowledgeGroupsModuleBuilder()
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

extension KnowledgeGroupsPresenterTestBuilder.Context {

    func simulateLoadingViewModel(_ viewModel: StubKnowledgeGroupsListViewModel = .random) {
        knowledgeInteractor.simulateViewModelPrepared(viewModel)
    }

}
