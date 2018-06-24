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

    init() {
        struct DummyCollectThemAllSceneFactory: CollectThemAllSceneFactory {
            func makeCollectThemAllScene() -> UIViewController & CollectThemAllScene {
                class DummyCollectThemAllScene: UIViewController, CollectThemAllScene {

                }

                return DummyCollectThemAllScene()
            }
        }

        sceneFactory = DummyCollectThemAllSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: CollectThemAllSceneFactory) -> CollectThemAllModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> CollectThemAllModuleProviding {
        return CollectThemAllModule(sceneFactory: sceneFactory)
    }

}
