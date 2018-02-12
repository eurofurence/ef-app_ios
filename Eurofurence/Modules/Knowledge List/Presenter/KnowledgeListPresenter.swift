//
//  KnowledgeListPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct KnowledgeListPresenter: KnowledgeListSceneDelegate {

    var scene: KnowledgeListScene
    var knowledgeListInteractor: KnowledgeInteractor

    func knowledgeListSceneWillAppear() {
        knowledgeListInteractor.prepareViewModel {
            self.scene.hideLoadingIndicator()
        }

        scene.showLoadingIndicator()
    }

}
