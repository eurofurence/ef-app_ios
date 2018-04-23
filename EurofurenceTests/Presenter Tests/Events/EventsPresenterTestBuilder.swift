//
//  EventsPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class EventsPresenterTestBuilder {
    
    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingEventsScene
    }
    
    func build() -> Context {
        let sceneFactory = StubEventsSceneFactory()
        let viewController = EventsModuleBuilder().with(sceneFactory).build().makeEventsModule()
        
        return Context(producedViewController: viewController, scene: sceneFactory.scene)
    }
    
}
