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

    private var eventsSceneFactory: EventsSceneFactory

    init() {
        eventsSceneFactory = StoryboardEventsSceneFactory()
    }

    @discardableResult
    func with(_ eventsSceneFactory: EventsSceneFactory) -> EventsModuleBuilder {
        self.eventsSceneFactory = eventsSceneFactory
        return self
    }

    func build() -> EventsModuleProviding {
        return EventsModule(eventsSceneFactory: eventsSceneFactory)
    }

}
