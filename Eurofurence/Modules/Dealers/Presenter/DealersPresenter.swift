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

    init(scene: DealersScene, interactor: DealersInteractor) {
        self.scene = scene

        interactor.makeDealersViewModel { (viewModel) in
            viewModel.setDelegate(self)
        }

        scene.setDelegate(self)
        scene.setDealersTitle(.dealers)
    }

    func dealersSceneDidLoad() {

    }

    func dealerGroupsDidChange(_ groups: [DealersGroupViewModel]) {
        let itemsPerSection = groups.map({ $0.dealers.count })
        scene.bind(numberOfDealersPerSection: itemsPerSection)
    }

}
