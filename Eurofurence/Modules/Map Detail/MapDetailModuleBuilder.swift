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

    init() {
        sceneFactory = StoryboardMapDetailSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: MapDetailSceneFactory) -> MapDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> MapDetailModuleProviding {
        return MapDetailModule(sceneFactory: sceneFactory)
    }

}
