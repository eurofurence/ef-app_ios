//
//  KnowledgeDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct KnowledgeDetailPresenter: KnowledgeDetailSceneDelegate {

    private let knowledgeDetailScene: KnowledgeDetailScene
    private let knowledgeEntry: KnowledgeEntry2
    private let knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor

    init(knowledgeDetailScene: KnowledgeDetailScene,
         knowledgeEntry: KnowledgeEntry2,
         knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor) {
        self.knowledgeDetailScene = knowledgeDetailScene
        self.knowledgeEntry = knowledgeEntry
        self.knowledgeDetailSceneInteractor = knowledgeDetailSceneInteractor

        knowledgeDetailScene.setKnowledgeDetailSceneDelegate(self)
        knowledgeDetailScene.setKnowledgeDetailTitle(knowledgeEntry.title)
    }

    func knowledgeDetailSceneDidLoad() {
        let contents = knowledgeDetailSceneInteractor.makeViewModel(for: knowledgeEntry).contents
        knowledgeDetailScene.setAttributedKnowledgeEntryContents(contents)
    }

}
