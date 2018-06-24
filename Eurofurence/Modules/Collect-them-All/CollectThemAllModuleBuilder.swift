//
//  CollectThemAllModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class CollectThemAllModuleBuilder {

    private var sceneFactory: CollectThemAllSceneFactory
    private var service: CollectThemAllService

    init() {
        struct DummyCollectThemAllService: CollectThemAllService {
            func subscribe(_ observer: CollectThemAllURLObserver) {

            }
        }

        sceneFactory = StoryboardCollectThemAllSceneFactory()
        service = DummyCollectThemAllService()
    }

    @discardableResult
    func with(_ sceneFactory: CollectThemAllSceneFactory) -> CollectThemAllModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ service: CollectThemAllService) -> CollectThemAllModuleBuilder {
        self.service = service
        return self
    }

    func build() -> CollectThemAllModuleProviding {
        return CollectThemAllModule(sceneFactory: sceneFactory, service: service)
    }

}
