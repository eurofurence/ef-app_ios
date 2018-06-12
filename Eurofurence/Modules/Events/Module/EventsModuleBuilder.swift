//
//  EventsModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIViewController

class EventsModuleBuilder {

    private var eventsSceneFactory: ScheduleSceneFactory

    init() {
        eventsSceneFactory = StoryboardScheduleSceneFactory()
    }

    @discardableResult
    func with(_ eventsSceneFactory: ScheduleSceneFactory) -> EventsModuleBuilder {
        self.eventsSceneFactory = eventsSceneFactory
        return self
    }

    func build() -> EventsModuleProviding {
        return EventsModule(eventsSceneFactory: eventsSceneFactory)
    }

}
