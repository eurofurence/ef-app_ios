//
//  KnowledgeDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel

class KnowledgeDetailPresenter: KnowledgeDetailSceneDelegate {

    private let delegate: KnowledgeDetailModuleDelegate
    private let knowledgeDetailScene: KnowledgeDetailScene
    private let identifier: KnowledgeEntry.Identifier
    private let knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor
    private var viewModel: KnowledgeEntryDetailViewModel?

    init(delegate: KnowledgeDetailModuleDelegate,
         knowledgeDetailScene: KnowledgeDetailScene,
         identifier: KnowledgeEntry.Identifier,
         knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor) {
        self.delegate = delegate
        self.knowledgeDetailScene = knowledgeDetailScene
        self.identifier = identifier
        self.knowledgeDetailSceneInteractor = knowledgeDetailSceneInteractor

        knowledgeDetailScene.setKnowledgeDetailSceneDelegate(self)
    }

    func knowledgeDetailSceneDidLoad() {
        knowledgeDetailSceneInteractor.makeViewModel(for: identifier, completionHandler: knowledgeDetailViewModelPrepared)
    }

    func knowledgeDetailSceneDidSelectLink(at index: Int) {
        guard let link = viewModel?.link(at: index) else { return }
        delegate.knowledgeDetailModuleDidSelectLink(link)
    }

    private func knowledgeDetailViewModelPrepared(_ viewModel: KnowledgeEntryDetailViewModel) {
        self.viewModel = viewModel

        let images: [KnowledgeEntryImageViewModel] = viewModel.images
        let imagesBinder = ViewModelImagesBinder(viewModels: images)
        knowledgeDetailScene.bindImages(count: images.count, using: imagesBinder)

        knowledgeDetailScene.setKnowledgeDetailTitle(viewModel.title)
        knowledgeDetailScene.setAttributedKnowledgeEntryContents(viewModel.contents)

        let links = viewModel.links

        if links.isEmpty == false {
            let binder = ViewModelLinksBinder(viewModels: links)
            knowledgeDetailScene.presentLinks(count: links.count, using: binder)
        }
    }

    private struct ViewModelImagesBinder: KnowledgentryImagesBinder {

        var viewModels: [KnowledgeEntryImageViewModel]

        func bind(_ scene: KnowledgeEntryImageScene, at index: Int) {
            let viewModel = viewModels[index]
            scene.showImagePNGData(viewModel.imagePNGData)
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
