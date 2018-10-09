//
//  StubLoginSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit.UIViewController

class StubLoginSceneFactory: LoginSceneFactory {
    
    let stubScene = CapturingLoginScene()
    func makeLoginScene() -> UIViewController & LoginScene {
        return stubScene
    }
    
}
