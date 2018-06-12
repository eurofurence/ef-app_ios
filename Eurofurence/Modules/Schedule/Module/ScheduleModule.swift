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

    func makeEventsModule() -> UIViewController {
        let scene = eventsSceneFactory.makeEventsScene()
        scene.setScheduleTitle(.events)

        return scene
    }

}
