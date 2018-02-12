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
        knowledgeListInteractor.prepareViewModel { (viewModel) in
            self.scene.hideLoadingIndicator()

            let entriesPerGroup = viewModel.knowledgeGroups.map({ $0.knowledgeEntries.count })
            self.scene.prepareToDisplayKnowledgeGroups(entriesPerGroup: entriesPerGroup, binder: ListBinder(viewModel: viewModel))
        }

        scene.showLoadingIndicator()
    }

    private struct ListBinder: KnowledgeListBinder {

        var viewModel: KnowledgeBaseViewModel

        func bind(_ header: KnowledgeGroupHeaderScene, toGroupAt index: Int) {
            let group = viewModel.knowledgeGroups[index]
            header.setKnowledgeGroupTitle(group.title)
        }

    }

}
