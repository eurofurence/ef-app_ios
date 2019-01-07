//
//  MapDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class MapDetailPresenter: MapDetailSceneDelegate {

    private let scene: MapDetailScene
    private let interactor: MapDetailInteractor
    private let identifier: MapIdentifier
    private let delegate: MapDetailModuleDelegate
    private var viewModel: MapDetailViewModel?

    init(scene: MapDetailScene,
         interactor: MapDetailInteractor,
         identifier: MapIdentifier,
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
        let (x, y) = (position.x, position.y)
        let visitor = ContentsVisitor(scene: scene, delegate: delegate, x: x, y: y)
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
    }

    private func viewModelReady(_ viewModel: MapDetailViewModel) {
        self.viewModel = viewModel

        scene.setMapImagePNGData(viewModel.mapImagePNGData)
        scene.setMapTitle(viewModel.mapName)
    }

    private struct ContentsVisitor: MapContentVisitor {

        var scene: MapDetailScene
        var delegate: MapDetailModuleDelegate
        var x: Float
        var y: Float

        func visit(_ mapPosition: MapCoordinate) {
            scene.focusMapPosition(mapPosition)
        }

        func visit(_ content: MapInformationContextualContent) {
            scene.show(contextualContent: content)
        }

        func visit(_ dealer: DealerIdentifier) {
            delegate.mapDetailModuleDidSelectDealer(dealer)
        }

        func visit(_ mapContents: MapContentOptionsViewModel) {
            scene.showMapOptions(heading: mapContents.optionsHeading,
                                 options: mapContents.options,
                                 atX: x,
                                 y: y,
                                 selectionHandler: mapContents.selectOption)
        }

    }

}
