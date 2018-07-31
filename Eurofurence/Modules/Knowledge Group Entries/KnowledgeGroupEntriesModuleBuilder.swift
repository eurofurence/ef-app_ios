//
//  KnowledgeGroupEntriesModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class KnowledgeGroupEntriesModuleBuilder {

    private var interactor: KnowledgeGroupEntriesInteractor
    private var sceneFactory: KnowledgeGroupEntriesSceneFactory

    init() {
        struct DummyKnowledgeGroupEntriesInteractor: KnowledgeGroupEntriesInteractor {
            func makeViewModelForGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void) {

            }
        }

        interactor = DummyKnowledgeGroupEntriesInteractor()
        sceneFactory = StoryboardKnowledgeGroupEntriesSceneFactory()
    }

    @discardableResult
    func with(_ interactor: KnowledgeGroupEntriesInteractor) -> KnowledgeGroupEntriesModuleBuilder {
        self.interactor = interactor
        return self
    }

    @discardableResult
    func with(_ sceneFactory: KnowledgeGroupEntriesSceneFactory) -> KnowledgeGroupEntriesModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> KnowledgeGroupEntriesModuleProviding {
        return KnowledgeGroupEntriesModule(interactor: interactor, sceneFactory: sceneFactory)
    }

}
