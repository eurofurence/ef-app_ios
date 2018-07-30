//
//  KnowledgeDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct KnowledgeDetailPresenter: KnowledgeDetailSceneDelegate {

    private let delegate: KnowledgeDetailModuleDelegate
    private let knowledgeDetailScene: KnowledgeDetailScene
    private let knowledgeEntry: KnowledgeEntry2
    private let knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor

    init(delegate: KnowledgeDetailModuleDelegate,
         knowledgeDetailScene: KnowledgeDetailScene,
         knowledgeEntry: KnowledgeEntry2,
         knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor) {
        self.delegate = delegate
        self.knowledgeDetailScene = knowledgeDetailScene
        self.knowledgeEntry = knowledgeEntry
        self.knowledgeDetailSceneInteractor = knowledgeDetailSceneInteractor

        knowledgeDetailScene.setKnowledgeDetailSceneDelegate(self)
        knowledgeDetailScene.setKnowledgeDetailTitle(knowledgeEntry.title)
    }

    func knowledgeDetailSceneDidLoad() {
        knowledgeDetailSceneInteractor.makeViewModel(for: knowledgeEntry.identifier, completionHandler: knowledgeDetailViewModelPrepared)
    }

    func knowledgeDetailSceneDidSelectLink(at index: Int) {
        let link = knowledgeEntry.links[index]
        delegate.knowledgeDetailModuleDidSelectLink(link)
    }

    private func knowledgeDetailViewModelPrepared(_ viewModel: KnowledgeEntryDetailViewModel) {
        knowledgeDetailScene.setAttributedKnowledgeEntryContents(viewModel.contents)

        let links = viewModel.links

        if links.isEmpty == false {
            let binder = ViewModelLinksBinder(viewModels: links)
            knowledgeDetailScene.presentLinks(count: links.count, using: binder)
        }
    }

    private struct ViewModelLinksBinder: LinksBinder {

        var viewModels: [LinkViewModel]

        func bind(_ scene: LinkScene, at index: Int) {
            let viewModel = viewModels[index]
            scene.setLinkName(viewModel.name)
        }

    }

}
