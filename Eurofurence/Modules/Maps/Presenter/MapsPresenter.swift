//
//  MapsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct MapsPresenter: MapsSceneDelegate {

    private let scene: MapsScene
    private let interactor: MapsInteractor

    init(scene: MapsScene, interactor: MapsInteractor) {
        self.scene = scene
        self.interactor = interactor

        scene.setMapsTitle(.maps)
        scene.setDelegate(self)
    }

    func mapsSceneDidLoad() {
        interactor.makeMapsViewModel { (viewModel) in
            self.scene.bind(numberOfMaps: viewModel.numberOfMaps)
        }
    }

}
