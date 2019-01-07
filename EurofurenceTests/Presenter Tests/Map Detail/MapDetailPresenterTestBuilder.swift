//
//  MapDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class CapturingMapDetailModuleDelegate: MapDetailModuleDelegate {

    private(set) var capturedDealerToShow: DealerIdentifier?
    func mapDetailModuleDidSelectDealer(_ identifier: DealerIdentifier) {
        capturedDealerToShow = identifier
    }

}

class MapDetailPresenterTestBuilder {

    struct Context {
        var scene: CapturingMapDetailScene
        var producedViewController: UIViewController
        var delegate: CapturingMapDetailModuleDelegate
    }

    private var interactor: MapDetailInteractor

    init() {
        interactor = FakeMapDetailInteractor()
    }

    @discardableResult
    func with(_ interactor: MapDetailInteractor) -> MapDetailPresenterTestBuilder {
        self.interactor = interactor
        return self
    }

    func build(for identifier: MapIdentifier = .random) -> Context {
        let sceneFactory = StubMapDetailSceneFactory()
        let delegate = CapturingMapDetailModuleDelegate()
        let module = MapDetailModuleBuilder()
            .with(sceneFactory)
            .with(interactor)
            .build()
            .makeMapDetailModule(for: identifier, delegate: delegate)

        return Context(scene: sceneFactory.scene, producedViewController: module, delegate: delegate)
    }

}

extension MapDetailPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.mapDetailSceneDidLoad()
    }

    func simulateSceneDidDidTapMap(at location: MapCoordinate) {
        scene.delegate?.mapDetailSceneDidTapMap(at: location)
    }

    func simulateSceneTappedMapOption(at index: Int) {
        scene.mapOptionSelectionHandler?(index)
    }

}
