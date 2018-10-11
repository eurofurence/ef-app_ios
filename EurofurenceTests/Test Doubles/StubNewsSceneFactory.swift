//
//  StubNewsSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit.UIViewController

class StubNewsSceneFactory: NewsSceneFactory {

    let stubbedScene = CapturingNewsScene()
    func makeNewsScene() -> UIViewController & NewsScene {
        return stubbedScene
    }

}
