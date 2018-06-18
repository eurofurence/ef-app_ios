//
//  DealersPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DealersPresenter: DealersSceneDelegate, DealersViewModelDelegate {

    private struct Binder: DealersBinder {

        var viewModels: [DealersGroupViewModel]

        func bind(_ component: DealerComponent, toDealerAt indexPath: IndexPath) {
            let group = viewModels[indexPath.section]
            let dealer = group.dealers[indexPath.item]

            component.setDealerTitle(dealer.title)
            component.setDealerSubtitle(dealer.subtitle)
            dealer.fetchIconPNGData(completionHandler: component.setDealerIconPNGData)

            if !dealer.isPresentForAllDays {
                component.showNotPresentOnAllDaysWarning()
            }

            component.hideNotPresentOnAllDaysWarning()
        }

    }

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
        scene.bind(numberOfDealersPerSection: itemsPerSection, using: Binder(viewModels: groups))
    }

}
