//
//  MapDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class MapDetailPresenterTestBuilder {
    
    struct Context {
        var scene: CapturingMapDetailScene
        var producedViewController: UIViewController
    }
    
    func build() -> Context {
        let sceneFactory = StubMapDetailSceneFactory()
        let module = MapDetailModuleBuilder()
            .with(sceneFactory)
            .build()
            .makeMapDetailModule(for: .random)
        
        return Context(scene: sceneFactory.scene, producedViewController: module)
    }
    
}
