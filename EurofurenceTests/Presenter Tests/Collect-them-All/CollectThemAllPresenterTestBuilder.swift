//
//  CollectThemAllPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit

class CollectThemAllPresenterTestBuilder {
    
    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingCollectThemAllScene
        var service: FakeCollectThemAllService
    }
    
    func build() -> Context {
        let sceneFactory = StubCollectThemAllSceneFactory()
        let service = FakeCollectThemAllService()
        let module = CollectThemAllModuleBuilder()
            .with(sceneFactory)
            .with(service)
            .build()
            .makeCollectThemAllModule()
        
        return Context(producedViewController: module,
                       scene: sceneFactory.interface,
                       service: service)
    }
    
}

extension CollectThemAllPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.delegate?.collectThemAllSceneDidLoad()
    }
    
}
