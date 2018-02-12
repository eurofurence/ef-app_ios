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

    func knowledgeListSceneDidLoad() {
        knowledgeListInteractor.prepareViewModel(completionHandler: viewModelPrepared)
        scene.showLoadingIndicator()
    }

    private func viewModelPrepared(_ viewModel: KnowledgeBaseViewModel) {
        scene.hideLoadingIndicator()

        let knowledgeGroups = viewModel.knowledgeGroups
        let entriesPerGroup = knowledgeGroups.map({ $0.knowledgeEntries.count })
        let binder = ListBinder(viewModel: viewModel)
        scene.prepareToDisplayKnowledgeGroups(entriesPerGroup: entriesPerGroup, binder: binder)
    }

    private struct ListBinder: KnowledgeListBinder {

        var viewModel: KnowledgeBaseViewModel

        func bind(_ header: KnowledgeGroupHeaderScene, toGroupAt index: Int) {
            let group = viewModel.knowledgeGroups[index]
            header.setKnowledgeGroupTitle(group.title)
        }

    }

}
