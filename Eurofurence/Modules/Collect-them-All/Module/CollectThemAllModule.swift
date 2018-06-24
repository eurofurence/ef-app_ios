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
        return sceneFactory.makeCollectThemAllScene()
    }

}
