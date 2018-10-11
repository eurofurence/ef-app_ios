//
//  StubMapDetailSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit

class StubMapDetailSceneFactory: MapDetailSceneFactory {

    let scene = CapturingMapDetailScene()
    func makeMapDetailScene() -> UIViewController & MapDetailScene {
        return scene
    }

}
