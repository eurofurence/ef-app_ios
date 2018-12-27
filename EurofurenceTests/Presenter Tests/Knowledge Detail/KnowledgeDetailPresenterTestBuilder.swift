//
//  KnowledgeDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import UIKit.UIViewController

class KnowledgeDetailPresenterTestBuilder {

    struct Context {
        var knowledgeEntryIdentifier: KnowledgeEntry.Identifier
        var knowledgeDetailScene: CapturingKnowledgeDetailScene
        var interactor: StubKnowledgeDetailSceneInteractor
        var module: UIViewController
        var delegate: CapturingKnowledgeDetailModuleDelegate
    }

    private var interactor = StubKnowledgeDetailSceneInteractor()

    @discardableResult
    func with(_ interactor: StubKnowledgeDetailSceneInteractor) -> KnowledgeDetailPresenterTestBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> Context {
        let knowledgeEntryIdentifier = KnowledgeEntry.Identifier.random
        let knowledgeDetailSceneFactory = StubKnowledgeDetailSceneFactory()
        let knowledgeDetailScene = knowledgeDetailSceneFactory.interface
        let delegate = CapturingKnowledgeDetailModuleDelegate()
        let moduleBuilder = KnowledgeDetailModuleBuilder()
            .with(knowledgeDetailSceneFactory)
            .with(interactor)
            .build()
        let module = moduleBuilder.makeKnowledgeListModule(knowledgeEntryIdentifier, delegate: delegate)

        return Context(knowledgeEntryIdentifier: knowledgeEntryIdentifier,
                       knowledgeDetailScene: knowledgeDetailScene,
                       interactor: interactor,
                       module: module,
                       delegate: delegate)
    }

}
