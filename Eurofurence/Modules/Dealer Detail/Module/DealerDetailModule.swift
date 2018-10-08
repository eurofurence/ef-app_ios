//
//  DealerDetailModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import UIKit

struct DealerDetailModule: DealerDetailModuleProviding {

    var dealerDetailSceneFactory: DealerDetailSceneFactory
    var dealerDetailInteractor: DealerDetailInteractor

    func makeDealerDetailModule(for dealer: Dealer2.Identifier) -> UIViewController {
        dealerDetailInteractor.makeDealerDetailViewModel(for: dealer) { (_) in }
        let scene = dealerDetailSceneFactory.makeDealerDetailScene()
        _ = DealerDetailPresenter(scene: scene, interactor: dealerDetailInteractor, dealer: dealer)

        return scene
    }

}
