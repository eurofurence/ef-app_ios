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

    func makeKnowledgeListModule(_ knowledgeEntry: KnowledgeEntry2) -> UIViewController {
        let scene = knowledgeDetailSceneFactory.makeKnowledgeDetailScene()
        _ = KnowledgeDetailPresenter(knowledgeDetailScene: scene,
                                     knowledgeEntry: knowledgeEntry)

        return scene
    }

}
