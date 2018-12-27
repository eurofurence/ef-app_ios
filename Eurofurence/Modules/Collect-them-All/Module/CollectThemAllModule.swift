//
//  CollectThemAllModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit

struct CollectThemAllModule: CollectThemAllModuleProviding {

    var sceneFactory: CollectThemAllSceneFactory
    var service: CollectThemAllService

    func makeCollectThemAllModule() -> UIViewController {
        let scene = sceneFactory.makeCollectThemAllScene()
        scene.setShortCollectThemAllTitle(.collect)
        scene.setCollectThemAllTitle(.collectThemAll)
        _ = CollectThemAllPresenter(scene: scene, service: service)

        return scene
    }

}
