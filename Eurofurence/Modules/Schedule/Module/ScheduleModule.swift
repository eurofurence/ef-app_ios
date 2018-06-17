//
//  ScheduleModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct ScheduleModule: ScheduleModuleProviding {

    var eventsSceneFactory: ScheduleSceneFactory
    var interactor: ScheduleInteractor

    func makeScheduleModule(_ delegate: ScheduleModuleDelegate) -> UIViewController {
        let scene = eventsSceneFactory.makeEventsScene()
        _ = SchedulePresenter(scene: scene, interactor: interactor, delegate: delegate)
        scene.setScheduleTitle(.schedule)

        return scene
    }

}
