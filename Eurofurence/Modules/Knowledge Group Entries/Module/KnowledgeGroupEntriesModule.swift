//
//  KnowledgeGroupEntriesModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct KnowledgeGroupEntriesModule: KnowledgeGroupEntriesModuleProviding {

    var interactor: KnowledgeGroupEntriesInteractor
    var sceneFactory: KnowledgeGroupEntriesSceneFactory

    func makeKnowledgeGroupEntriesModule(_ groupIdentifier: KnowledgeGroup2.Identifier, delegate: KnowledgeGroupEntriesModuleDelegate) {
        let scene = sceneFactory.makeKnowledgeGroupEntriesScene()
        _ = KnowledgeGroupEntriesPresenter(scene: scene,
                                           interactor: interactor,
                                           groupIdentifier: groupIdentifier,
                                           delegate: delegate)
    }

}
