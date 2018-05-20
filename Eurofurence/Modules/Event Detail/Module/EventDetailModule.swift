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
    var interactor: EventDetailInteractor

    func makeEventDetailModule(for event: Event2) -> UIViewController {
        let scene = sceneFactory.makeEventDetailScene()
        _ = EventDetailPresenter(scene: scene, interactor: interactor, event: event)

        return scene
    }

}
