//
//  EventDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import UIKit.UIViewController

class EventDetailPresenterTestBuilder {
    
    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingEventDetailScene
    }
    
    func build() -> Context {
        let sceneFactory = StubEventDetailSceneFactory()
        let module = EventDetailModuleBuilder()
            .with(sceneFactory)
            .build()
            .makeEventDetailModule(for: .random)
        
        return Context(producedViewController: module, scene: sceneFactory.interface)
    }
    
}
