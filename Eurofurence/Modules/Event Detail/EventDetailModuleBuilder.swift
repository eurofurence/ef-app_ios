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
    private var interactor: EventDetailInteractor

    init() {
        sceneFactory = StoryboardEventDetailSceneFactory()
        interactor = DefaultEventDetailInteractor()
    }

    @discardableResult
    func with(_ sceneFactory: EventDetailSceneFactory) -> EventDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ interactor: EventDetailInteractor) -> EventDetailModuleBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> EventDetailModuleProviding {
        return EventDetailModule(sceneFactory: sceneFactory, interactor: interactor)
    }

}
