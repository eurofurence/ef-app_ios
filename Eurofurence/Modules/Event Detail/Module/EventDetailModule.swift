//
//  EventDetailModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation
import UIKit.UIViewController

struct EventDetailModule: EventDetailModuleProviding {

    var sceneFactory: EventDetailSceneFactory
    var interactor: EventDetailInteractor
    var hapticEngine: HapticEngine

    func makeEventDetailModule(for event: Event.Identifier) -> UIViewController {
        let scene = sceneFactory.makeEventDetailScene()
        _ = EventDetailPresenter(scene: scene,
                                 interactor: interactor,
                                 hapticEngine: hapticEngine,
                                 event: event)

        return scene
    }

}
