//
//  DealerDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DealerDetailPresenter {

    init(scene: DealerDetailScene, interactor: DealerDetailInteractor, dealer: Dealer2.Identifier) {
        interactor.makeDealerDetailViewModel(for: dealer) { (viewModel) in
            scene.bind(numberOfComponents: viewModel.numberOfComponents)
        }
    }

}
