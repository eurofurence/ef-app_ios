//
//  KnowledgeDetailModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit.UIViewController

struct KnowledgeDetailModule: KnowledgeDetailModuleProviding {

    var knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory
    var knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor

    func makeKnowledgeListModule(_ identifier: KnowledgeEntryIdentifier, delegate: KnowledgeDetailModuleDelegate) -> UIViewController {
        let scene = knowledgeDetailSceneFactory.makeKnowledgeDetailScene()
        _ = KnowledgeDetailPresenter(delegate: delegate,
                                     knowledgeDetailScene: scene,
                                     identifier: identifier,
                                     knowledgeDetailSceneInteractor: knowledgeDetailSceneInteractor)

        return scene
    }

}
