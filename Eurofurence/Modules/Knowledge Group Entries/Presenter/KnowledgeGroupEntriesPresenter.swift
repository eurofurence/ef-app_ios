//
//  KnowledgeGroupEntriesPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct KnowledgeGroupEntriesPresenter: KnowledgeGroupEntriesSceneDelegate {

    private let scene: KnowledgeGroupEntriesScene
    private let interactor: KnowledgeGroupEntriesInteractor
    private let groupIdentifier: KnowledgeGroup2.Identifier

    init(scene: KnowledgeGroupEntriesScene,
         interactor: KnowledgeGroupEntriesInteractor,
         groupIdentifier: KnowledgeGroup2.Identifier) {
        self.scene = scene
        self.interactor = interactor
        self.groupIdentifier = groupIdentifier

        scene.setDelegate(self)
    }

    func knowledgeGroupEntriesSceneDidLoad() {
        interactor.makeViewModelForGroup(identifier: groupIdentifier, completionHandler: viewModelReady)
    }

    private func viewModelReady(_ viewModel: KnowledgeGroupEntriesViewModel) {
        scene.bind(numberOfEntries: viewModel.numberOfEntries)
    }

}
