//
//  MapsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct MapsPresenter {

    init(scene: MapsScene, interactor: MapsInteractor) {
        scene.setMapsTitle(.maps)

        interactor.makeMapsViewModel { (viewModel) in
            scene.bind(numberOfMaps: viewModel.numberOfMaps)
        }
    }

}
