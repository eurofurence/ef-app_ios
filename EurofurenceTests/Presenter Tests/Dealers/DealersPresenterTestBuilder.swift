//
//  DealersPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class DealersPresenterTestBuilder {
    
    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingDealersScene
    }
    
    func build() -> Context {
        let sceneFactory = StubDealersSceneFactory()
        let viewController = DealersModuleBuilder().with(sceneFactory).build().makeDealersModule()
        
        return Context(producedViewController: viewController,
                       scene: sceneFactory.scene)
    }
    
}
