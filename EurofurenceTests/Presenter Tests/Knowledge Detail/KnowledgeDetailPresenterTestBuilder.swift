//
//  KnowledgeDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class KnowledgeDetailPresenterTestBuilder {
    
    struct Context {
        var knowledgeEntry: KnowledgeEntry2
        var knowledgeDetailScene: CapturingKnowledgeDetailScene
        var interactor: StubKnowledgeDetailSceneInteractor
        var module: UIViewController
    }
    
    private var interactor = StubKnowledgeDetailSceneInteractor()
    
    @discardableResult
    func with(_ interactor: StubKnowledgeDetailSceneInteractor) -> KnowledgeDetailPresenterTestBuilder {
        self.interactor = interactor
        return self
    }
    
    func build() -> Context {
        let knowledgeEntry = KnowledgeEntry2.random
        let knowledgeDetailSceneFactory = StubKnowledgeDetailSceneFactory()
        let knowledgeDetailScene = knowledgeDetailSceneFactory.interface
        let moduleBuilder = KnowledgeDetailModuleBuilder()
            .with(knowledgeDetailSceneFactory)
            .with(interactor)
            .build()
        let module = moduleBuilder.makeKnowledgeListModule(knowledgeEntry)
        
        return Context(knowledgeEntry: knowledgeEntry,
                       knowledgeDetailScene: knowledgeDetailScene,
                       interactor: interactor,
                       module: module)
    }
    
}
