//
//  DealersModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct DealersModule: DealersModuleProviding {

    var dealersSceneFactory: DealersSceneFactory

    func makeDealersModule() -> UIViewController {
        let scene = dealersSceneFactory.makeDealersScene()
        scene.setDealersTitle(.dealers)

        return scene
    }

}
