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

        struct DummyKnowledgeGroupEntriesSceneFactory: KnowledgeGroupEntriesSceneFactory {
            func makeKnowledgeGroupEntriesScene() -> KnowledgeGroupEntriesScene {
                struct DummyKnowledgeGroupEntriesScene: KnowledgeGroupEntriesScene {
                    func setDelegate(_ delegate: KnowledgeGroupEntriesSceneDelegate) {

                    }
                    func bind(numberOfEntries: Int) {

                    }
                }

                return DummyKnowledgeGroupEntriesScene()
            }
        }

        interactor = DummyKnowledgeGroupEntriesInteractor()
        sceneFactory = DummyKnowledgeGroupEntriesSceneFactory()
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
