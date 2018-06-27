//
//  MapDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct MapDetailPresenter {

    init(scene: MapDetailScene, interactor: MapDetailInteractor, identifier: Map2.Identifier) {
        interactor.makeViewModelForMap(identifier: identifier) { (viewModel) in
            scene.setMapImagePNGData(viewModel.mapImagePNGData)
            scene.setMapTitle(viewModel.mapName)
        }
    }

}
