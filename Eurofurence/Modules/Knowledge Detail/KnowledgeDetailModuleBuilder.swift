//
//  KnowledgeDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class KnowledgeDetailModuleBuilder {

    private var knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory
    private var knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor

    init() {
        struct DummyKnowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor {
            func makeContents(for entry: KnowledgeEntry2) -> NSAttributedString {
                return NSAttributedString()
            }
        }

        knowledgeDetailSceneFactory = StoryboardKnowledgeDetailSceneFactory()
        knowledgeDetailSceneInteractor = DummyKnowledgeDetailSceneInteractor()
    }

    @discardableResult
    func with(_ knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory) -> KnowledgeDetailModuleBuilder {
        self.knowledgeDetailSceneFactory = knowledgeDetailSceneFactory
        return self
    }

    @discardableResult
    func with(_ knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor) -> KnowledgeDetailModuleBuilder {
        self.knowledgeDetailSceneInteractor = knowledgeDetailSceneInteractor
        return self
    }

    func build() -> KnowledgeDetailModuleProviding {
        return KnowledgeDetailModule(knowledgeDetailSceneFactory: knowledgeDetailSceneFactory,
                                     knowledgeDetailSceneInteractor: knowledgeDetailSceneInteractor)
    }

}
