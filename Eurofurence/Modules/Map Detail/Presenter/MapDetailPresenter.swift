//
//  MapDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct MapDetailPresenter: MapDetailSceneDelegate {

    private let scene: MapDetailScene
    private let interactor: MapDetailInteractor
    private let identifier: Map2.Identifier

    init(scene: MapDetailScene, interactor: MapDetailInteractor, identifier: Map2.Identifier) {
        self.scene = scene
        self.interactor = interactor
        self.identifier = identifier

        scene.setDelegate(self)
    }

    func mapDetailSceneDidLoad() {
        interactor.makeViewModelForMap(identifier: identifier, completionHandler: viewModelReady)
    }

    private func viewModelReady(_ viewModel: MapDetailViewModel) {
        scene.setMapImagePNGData(viewModel.mapImagePNGData)
        scene.setMapTitle(viewModel.mapName)
    }

}
