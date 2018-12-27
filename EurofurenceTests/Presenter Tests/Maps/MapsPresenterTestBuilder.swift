//
//  MapsPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import UIKit

class MapsPresenterTestBuilder {

    struct Context {
        var scene: CapturingMapsScene
        var producedViewController: UIViewController
        var delegate: CapturingMapsModuleDelegate
    }

    private var interactor: MapsInteractor

    init() {
        interactor = FakeMapsInteractor()
    }

    @discardableResult
    func with(_ interactor: MapsInteractor) -> MapsPresenterTestBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> Context {
        let sceneFactory = StubMapsSceneFactory()
        let delegate = CapturingMapsModuleDelegate()
        let module = MapsModuleBuilder()
            .with(interactor)
            .with(sceneFactory)
            .build()
            .makeMapsModule(delegate)

        return Context(scene: sceneFactory.scene,
                       producedViewController: module,
                       delegate: delegate)
    }

}

extension MapsPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.mapsSceneDidLoad()
    }

    func simulateSceneDidSelectMap(at index: Int) {
        scene.delegate?.simulateSceneDidSelectMap(at: index)
    }

    func bindMap(at index: Int) -> CapturingMapComponent {
        let component = CapturingMapComponent()
        scene.binder?.bind(component, at: index)
        return component
    }

}
