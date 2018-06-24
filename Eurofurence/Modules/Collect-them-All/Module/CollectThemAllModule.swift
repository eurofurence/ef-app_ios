//
//  CollectThemAllModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct CollectThemAllModule: CollectThemAllModuleProviding {

    var sceneFactory: CollectThemAllSceneFactory

    func makeCollectThemAllModule() -> UIViewController {
        let scene = sceneFactory.makeCollectThemAllScene()
        scene.setShortCollectThemAllTitle(.collect)

        return scene
    }

}
