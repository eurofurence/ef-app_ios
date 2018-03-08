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

    func makeKnowledgeListModule(_ knowledgeEntryViewModel: KnowledgeEntryViewModel) -> UIViewController {
        let scene = knowledgeDetailSceneFactory.makeKnowledgeDetailScene()
        _ = KnowledgeDetailPresenter(knowledgeDetailScene: scene,
                                     viewModel: knowledgeEntryViewModel)

        return scene
    }

}
