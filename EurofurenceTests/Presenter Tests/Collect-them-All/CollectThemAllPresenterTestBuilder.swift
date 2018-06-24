//
//  CollectThemAllPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class CollectThemAllPresenterTestBuilder {
    
    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingCollectThemAllScene
    }
    
    func build() -> Context {
        let sceneFactory = StubCollectThemAllSceneFactory()
        let module = CollectThemAllModuleBuilder()
            .with(sceneFactory)
            .build()
            .makeCollectThemAllModule()
        
        return Context(producedViewController: module,
                       scene: sceneFactory.interface)
    }
    
}
