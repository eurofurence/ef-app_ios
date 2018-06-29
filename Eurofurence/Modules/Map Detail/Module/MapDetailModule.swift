//
//  MapDetailModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct MapDetailModule: MapDetailModuleProviding {

    var sceneFactory: MapDetailSceneFactory
    var interactor: MapDetailInteractor

    func makeMapDetailModule(for map: Map2.Identifier, delegate: MapDetailModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeMapDetailScene()
        _ = MapDetailPresenter(scene: scene, interactor: interactor, identifier: map, delegate: delegate)

        return scene
    }

}
