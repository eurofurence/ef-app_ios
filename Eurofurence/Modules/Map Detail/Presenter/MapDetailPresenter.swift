//
//  MapDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class MapDetailPresenter: MapDetailSceneDelegate, MapContentVisitor {

    private let scene: MapDetailScene
    private let interactor: MapDetailInteractor
    private let identifier: Map2.Identifier
    private let delegate: MapDetailModuleDelegate
    private var viewModel: MapDetailViewModel?

    init(scene: MapDetailScene,
         interactor: MapDetailInteractor,
         identifier: Map2.Identifier,
         delegate: MapDetailModuleDelegate) {
        self.scene = scene
        self.interactor = interactor
        self.identifier = identifier
        self.delegate = delegate

        scene.setDelegate(self)
    }

    func mapDetailSceneDidLoad() {
        interactor.makeViewModelForMap(identifier: identifier, completionHandler: viewModelReady)
    }

    func mapDetailSceneDidTapMap(at position: MapCoordinate) {
        viewModel?.showContentsAtPosition(x: position.x, y: position.y, describingTo: self)
    }

    private func viewModelReady(_ viewModel: MapDetailViewModel) {
        self.viewModel = viewModel

        scene.setMapImagePNGData(viewModel.mapImagePNGData)
        scene.setMapTitle(viewModel.mapName)
    }

    func visit(_ mapPosition: MapCoordinate) {
        scene.focusMapPosition(mapPosition)
    }

    func visit(_ content: MapInformationContextualContent) {
        scene.show(contextualContent: content)
    }

    func visit(_ dealer: Dealer2.Identifier) {
        delegate.mapDetailModuleDidSelectDealer(dealer)
    }

}
