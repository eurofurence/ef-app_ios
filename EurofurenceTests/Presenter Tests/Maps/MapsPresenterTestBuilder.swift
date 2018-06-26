//
//  MapsPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class MapsPresenterTestBuilder {
    
    struct Context {
        var scene: CapturingMapsScene
        var producedViewController: UIViewController
    }
    
    func build() -> Context {
        let sceneFactory = StubMapsSceneFactory()
        let module = MapsModuleBuilder().with(sceneFactory).build().makeMapsModule()
        
        return Context(scene: sceneFactory.scene, producedViewController: module)
    }
    
}
