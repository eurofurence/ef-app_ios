//
//  SchedulePresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class SchedulePresenterTestBuilder {
    
    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingScheduleScene
    }
    
    func build() -> Context {
        let sceneFactory = StubScheduleSceneFactory()
        let viewController = ScheduleModuleBuilder().with(sceneFactory).build().makeEventsModule()
        
        return Context(producedViewController: viewController, scene: sceneFactory.scene)
    }
    
}
