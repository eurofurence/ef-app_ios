//
//  EventDetailModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIViewController

struct EventDetailModule: EventDetailModuleProviding {

    var sceneFactory: EventDetailSceneFactory

    func makeEventDetailModule(for event: Event2) -> UIViewController {
        return sceneFactory.makeEventDetailScene()
    }

}
