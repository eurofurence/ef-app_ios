//
//  MapsModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct MapsModule: MapsModuleProviding {

    var sceneFactory: MapsSceneFactory

    func makeMapsModule() -> UIViewController {
        return sceneFactory.makeMapsScene()
    }

}
