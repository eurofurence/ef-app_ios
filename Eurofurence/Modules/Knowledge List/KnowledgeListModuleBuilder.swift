//
//  KnowledgeListModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

class KnowledgeListModuleBuilder {

    private var knowledgeListInteractor: KnowledgeInteractor
    private var knowledgeSceneFactory: KnowledgeListSceneFactory

    init() {
        struct DummyKnowledgeInteractor: KnowledgeInteractor {
            func prepareViewModel() {

            }
        }

        struct DummyKnowledgeListSceneFactory: KnowledgeListSceneFactory {
            func makeKnowledgeListScene() -> KnowledgeListScene {
                struct DummyKnowledgeListScene: KnowledgeListScene {
                    func showLoadingIndicator() {
                    }

                    func setDelegate(_ delegate: KnowledgeListSceneDelegate) {
                    }
                }

                return DummyKnowledgeListScene()
            }
        }

        knowledgeListInteractor = DummyKnowledgeInteractor()
        knowledgeSceneFactory = DummyKnowledgeListSceneFactory()
    }

    @discardableResult
    func with(_ knowledgeListInteractor: KnowledgeInteractor) -> KnowledgeListModuleBuilder {
        self.knowledgeListInteractor = knowledgeListInteractor
        return self
    }

    @discardableResult
    func with(_ knowledgeSceneFactory: KnowledgeListSceneFactory) -> KnowledgeListModuleBuilder {
        self.knowledgeSceneFactory = knowledgeSceneFactory
        return self
    }

    func build() -> KnowledgeListModuleProviding {
        return KnowledgeListModule(knowledgeSceneFactory: knowledgeSceneFactory,
                                   knowledgeListInteractor: knowledgeListInteractor)
    }

}
