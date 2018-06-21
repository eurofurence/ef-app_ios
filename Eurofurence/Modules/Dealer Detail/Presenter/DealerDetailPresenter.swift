//
//  DealerDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DealerDetailPresenter: DealerDetailSceneDelegate {

    private let scene: DealerDetailScene
    private let interactor: DealerDetailInteractor
    private let dealer: Dealer2.Identifier

    init(scene: DealerDetailScene, interactor: DealerDetailInteractor, dealer: Dealer2.Identifier) {
        self.scene = scene
        self.interactor = interactor
        self.dealer = dealer

        scene.setDelegate(self)
    }

    func dealerDetailSceneDidLoad() {
        interactor.makeDealerDetailViewModel(for: dealer) { (viewModel) in
            self.scene.bind(numberOfComponents: viewModel.numberOfComponents)
        }
    }

}
