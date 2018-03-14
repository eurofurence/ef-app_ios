//
//  KnowledgeDetailModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct KnowledgeDetailModule: KnowledgeDetailModuleProviding {

    var knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory
    var knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor

    func makeKnowledgeListModule(_ knowledgeEntry: KnowledgeEntry2, delegate: KnowledgeDetailModuleDelegate) -> UIViewController {
        let scene = knowledgeDetailSceneFactory.makeKnowledgeDetailScene()
        _ = KnowledgeDetailPresenter(delegate: delegate,
                                     knowledgeDetailScene: scene,
                                     knowledgeEntry: knowledgeEntry,
                                     knowledgeDetailSceneInteractor: knowledgeDetailSceneInteractor)

        return scene
    }

}
