//
//  DealersPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DealersPresenter: DealersSceneDelegate, DealersViewModelDelegate {

    private let scene: DealersScene
    private let interactor: DealersInteractor

    init(scene: DealersScene, interactor: DealersInteractor) {
        self.scene = scene
        self.interactor = interactor

        scene.setDelegate(self)
        scene.setDealersTitle(.dealers)
    }

    func dealersSceneDidLoad() {
        interactor.makeDealersViewModel { (viewModel) in
            viewModel.setDelegate(self)
        }
    }

    func dealerGroupsDidChange(_ groups: [DealersGroupViewModel]) {
        let itemsPerSection = groups.map({ $0.dealers.count })
        scene.bind(numberOfDealersPerSection: itemsPerSection)
    }

}
