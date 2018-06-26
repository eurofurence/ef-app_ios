//
//  MapsModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class MapsModuleBuilder {

    private var sceneFactory: MapsSceneFactory

    init() {
        sceneFactory = StoryboardMapsScenefactory()
    }

    @discardableResult
    func with(_ sceneFactory: MapsSceneFactory) -> MapsModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> MapsModuleProviding {
        return MapsModule(sceneFactory: sceneFactory)
    }

}
