//
//  KnowledgeGroupsListPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation.NSIndexPath

class KnowledgeGroupsListPresenter: KnowledgeListSceneDelegate {

    private let scene: KnowledgeListScene
    private let knowledgeListInteractor: KnowledgeGroupsInteractor
    private let delegate: KnowledgeGroupsListModuleDelegate
    private var viewModel: KnowledgeGroupsListViewModel?

    init(scene: KnowledgeListScene,
         knowledgeListInteractor: KnowledgeGroupsInteractor,
         delegate: KnowledgeGroupsListModuleDelegate) {
        self.scene = scene
        self.knowledgeListInteractor = knowledgeListInteractor
        self.delegate = delegate

        scene.setKnowledgeListTitle(.conventionInformation)
        scene.setKnowledgeListShortTitle(.information)
    }

    func knowledgeListSceneDidLoad() {
        scene.showLoadingIndicator()
        knowledgeListInteractor.prepareViewModel(completionHandler: viewModelPrepared)
    }

    func knowledgeListSceneDidSelectKnowledgeGroup(at groupIndex: Int) {
        scene.deselectKnowledgeEntry(at: IndexPath(item: groupIndex, section: 0))
        viewModel?.fetchIdentifierForGroup(at: groupIndex, completionHandler: delegate.knowledgeListModuleDidSelectKnowledgeGroup)
    }

    private func viewModelPrepared(_ viewModel: KnowledgeGroupsListViewModel) {
        self.viewModel = viewModel
        scene.hideLoadingIndicator()

        let knowledgeGroups = viewModel.knowledgeGroups
        let binder = ListBinder(viewModel: viewModel)
        scene.prepareToDisplayKnowledgeGroups(numberOfGroups: knowledgeGroups.count, binder: binder)
    }

    private struct ListBinder: KnowledgeListBinder {

        var viewModel: KnowledgeGroupsListViewModel

        func bind(_ header: KnowledgeGroupScene, toGroupAt index: Int) {
            let group = viewModel.knowledgeGroups[index]

            header.setKnowledgeGroupTitle(group.title)
            header.setKnowledgeGroupIcon(group.icon)
            header.setKnowledgeGroupDescription(group.groupDescription)
        }

    }

}
