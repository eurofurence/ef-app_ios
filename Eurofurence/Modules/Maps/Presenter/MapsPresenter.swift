//
//  MapsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct MapsPresenter: MapsSceneDelegate {

    private struct Binder: MapsBinder {

        var viewModel: MapsViewModel

        func bind(_ component: MapComponent, at index: Int) {
            let map = viewModel.mapViewModel(at: index)

            component.setMapName(map.mapName)
            component.setMapPreviewImagePNGData(map.mapPreviewImagePNGData)
        }

    }

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
            self.scene.bind(numberOfMaps: viewModel.numberOfMaps, using: Binder(viewModel: viewModel))
        }
    }

}
