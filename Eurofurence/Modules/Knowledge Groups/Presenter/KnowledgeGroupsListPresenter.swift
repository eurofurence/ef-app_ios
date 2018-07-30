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

    func knowledgeListSceneDidSelectKnowledgeEntry(inGroup groupIndex: Int, at entryIndex: Int) {
        scene.deselectKnowledgeEntry(at: IndexPath(item: entryIndex, section: groupIndex))

        knowledgeListInteractor.fetchEntry(inGroup: groupIndex, index: entryIndex) { (entry) in
            self.delegate.knowledgeListModuleDidSelectKnowledgeEntry(entry)
        }
    }

    private func viewModelPrepared(_ viewModel: KnowledgeGroupsListViewModel) {
        self.viewModel = viewModel
        scene.hideLoadingIndicator()

        let knowledgeGroups = viewModel.knowledgeGroups
        let entriesPerGroup = knowledgeGroups.map({ $0.knowledgeEntries.count })
        let binder = ListBinder(viewModel: viewModel)
        scene.prepareToDisplayKnowledgeGroups(entriesPerGroup: entriesPerGroup, binder: binder)
    }

    private struct ListBinder: KnowledgeListBinder {

        var viewModel: KnowledgeGroupsListViewModel

        func bind(_ header: KnowledgeGroupScene, toGroupAt index: Int) {
            let group = viewModel.knowledgeGroups[index]

            header.setKnowledgeGroupTitle(group.title)
            header.setKnowledgeGroupIcon(group.icon)
            header.setKnowledgeGroupDescription(group.groupDescription)
        }

        func bind(_ entryScene: KnowledgeGroupEntryScene, toEntryInGroup groupIndex: Int, at entryIndex: Int) {
            let group = viewModel.knowledgeGroups[groupIndex]
            let entry = group.knowledgeEntries[entryIndex]
            entryScene.setKnowledgeEntryTitle(entry.title)
        }

    }

}
