//
//  MapsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class MapsPresenter: MapsSceneDelegate {

    private struct Binder: MapsBinder {

        var viewModel: MapsViewModel

        func bind(_ component: MapComponent, at index: Int) {
            let map = viewModel.mapViewModel(at: index)

            component.setMapName(map.mapName)
            map.fetchMapPreviewPNGData(completionHandler: component.setMapPreviewImagePNGData)
        }

    }

    private let scene: MapsScene
    private let interactor: MapsInteractor
    private let delegate: MapsModuleDelegate
    private var viewModel: MapsViewModel?

    init(scene: MapsScene, interactor: MapsInteractor, delegate: MapsModuleDelegate) {
        self.scene = scene
        self.interactor = interactor
        self.delegate = delegate

        scene.setMapsTitle(.maps)
        scene.setDelegate(self)
    }

    func mapsSceneDidLoad() {
        interactor.makeMapsViewModel { (viewModel) in
            self.viewModel = viewModel
            self.scene.bind(numberOfMaps: viewModel.numberOfMaps, using: Binder(viewModel: viewModel))
        }
    }

    func simulateSceneDidSelectMap(at index: Int) {
        guard let identifier = viewModel?.identifierForMap(at: index) else { return }
        delegate.mapsModuleDidSelectMap(identifier: identifier)
    }

}
