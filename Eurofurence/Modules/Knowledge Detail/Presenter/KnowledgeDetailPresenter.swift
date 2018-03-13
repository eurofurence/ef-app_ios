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
        let viewModel = knowledgeDetailSceneInteractor.makeViewModel(for: knowledgeEntry)
        knowledgeDetailScene.setAttributedKnowledgeEntryContents(viewModel.contents)

        let links = viewModel.links
        let binder = ViewModelLinksBinder(viewModels: links)
        knowledgeDetailScene.presentLinks(count: links.count, using: binder)
    }

    private struct ViewModelLinksBinder: LinksBinder {

        var viewModels: [LinkViewModel]

        func bind(_ scene: LinkScene, at index: Int) {
            let viewModel = viewModels[index]
            scene.setLinkSame(viewModel.name)
        }

    }

}
