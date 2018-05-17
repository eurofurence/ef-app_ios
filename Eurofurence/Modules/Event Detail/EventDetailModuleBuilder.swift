//
//  EventDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIViewController

class EventDetailModuleBuilder {

    private var sceneFactory: EventDetailSceneFactory

    init() {
        struct DummyEventDetailSceneFactory: EventDetailSceneFactory {
            func makeEventDetailScene() -> UIViewController & EventDetailScene {
                class DummyEventDetailScene: UIViewController, EventDetailScene {

                }

                return DummyEventDetailScene()
            }
        }

        sceneFactory = DummyEventDetailSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: EventDetailSceneFactory) -> EventDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> EventDetailModuleProviding {
        return EventDetailModule(sceneFactory: sceneFactory)
    }

}
