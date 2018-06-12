//
//  ScheduleModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIViewController

class ScheduleModuleBuilder {

    private var eventsSceneFactory: ScheduleSceneFactory

    init() {
        eventsSceneFactory = StoryboardScheduleSceneFactory()
    }

    @discardableResult
    func with(_ eventsSceneFactory: ScheduleSceneFactory) -> ScheduleModuleBuilder {
        self.eventsSceneFactory = eventsSceneFactory
        return self
    }

    func build() -> ScheduleModuleProviding {
        return ScheduleModule(eventsSceneFactory: eventsSceneFactory)
    }

}
