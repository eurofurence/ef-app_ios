//
//  KnowledgeGroupsModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel

class KnowledgeGroupsModuleBuilder {

    private var knowledgeListInteractor: KnowledgeGroupsInteractor
    private var knowledgeSceneFactory: KnowledgeListSceneFactory

    init() {
        knowledgeListInteractor = DefaultKnowledgeGroupsInteractor(service: SharedModel.instance.session)
        knowledgeSceneFactory = StoryboardKnowledgeListSceneFactory()
    }

    @discardableResult
    func with(_ knowledgeListInteractor: KnowledgeGroupsInteractor) -> KnowledgeGroupsModuleBuilder {
        self.knowledgeListInteractor = knowledgeListInteractor
        return self
    }

    @discardableResult
    func with(_ knowledgeSceneFactory: KnowledgeListSceneFactory) -> KnowledgeGroupsModuleBuilder {
        self.knowledgeSceneFactory = knowledgeSceneFactory
        return self
    }

    func build() -> KnowledgeGroupsListModuleProviding {
        return KnowledgeListModule(knowledgeSceneFactory: knowledgeSceneFactory,
                                   knowledgeListInteractor: knowledgeListInteractor)
    }

}
