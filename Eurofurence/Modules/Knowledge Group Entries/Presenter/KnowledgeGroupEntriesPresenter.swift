//
//  KnowledgeGroupEntriesPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class KnowledgeGroupEntriesPresenter: KnowledgeGroupEntriesSceneDelegate {

    private struct Binder: KnowledgeGroupEntriesBinder {

        var viewModel: KnowledgeGroupEntriesViewModel

        func bind(_ component: KnowledgeGroupEntryScene, at index: Int) {
            let entryViewModel = viewModel.knowledgeEntry(at: index)
            component.setKnowledgeEntryTitle(entryViewModel.title)
        }

    }

    private let scene: KnowledgeGroupEntriesScene
    private let interactor: KnowledgeGroupEntriesInteractor
    private let groupIdentifier: KnowledgeGroup.Identifier
    private let delegate: KnowledgeGroupEntriesModuleDelegate
    private var viewModel: KnowledgeGroupEntriesViewModel?

    init(scene: KnowledgeGroupEntriesScene,
         interactor: KnowledgeGroupEntriesInteractor,
         groupIdentifier: KnowledgeGroup.Identifier,
         delegate: KnowledgeGroupEntriesModuleDelegate) {
        self.scene = scene
        self.interactor = interactor
        self.groupIdentifier = groupIdentifier
        self.delegate = delegate

        scene.setDelegate(self)
    }

    func knowledgeGroupEntriesSceneDidLoad() {
        interactor.makeViewModelForGroup(identifier: groupIdentifier, completionHandler: viewModelReady)
    }

    func knowledgeGroupEntriesSceneDidSelectEntry(at index: Int) {
        guard let identifier = viewModel?.identifierForKnowledgeEntry(at: index) else { return }
        delegate.knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: identifier)
    }

    private func viewModelReady(_ viewModel: KnowledgeGroupEntriesViewModel) {
        self.viewModel = viewModel
        scene.setKnowledgeGroupTitle(viewModel.title)
        scene.bind(numberOfEntries: viewModel.numberOfEntries, using: Binder(viewModel: viewModel))
    }

}
