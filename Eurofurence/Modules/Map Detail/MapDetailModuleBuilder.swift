//
//  MapDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class MapDetailModuleBuilder {

    private var sceneFactory: MapDetailSceneFactory
    private var interactor: MapDetailInteractor

    init() {
        struct DummyMapDetailInteractor: MapDetailInteractor {
            func makeViewModelForMap(identifier: Map2.Identifier, completionHandler: @escaping (MapDetailViewModel) -> Void) {

            }
        }

        sceneFactory = StoryboardMapDetailSceneFactory()
        interactor = DummyMapDetailInteractor()
    }

    @discardableResult
    func with(_ sceneFactory: MapDetailSceneFactory) -> MapDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ interactor: MapDetailInteractor) -> MapDetailModuleBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> MapDetailModuleProviding {
        return MapDetailModule(sceneFactory: sceneFactory, interactor: interactor)
    }

}
