//
//  StubCollectThemAllSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit

class StubCollectThemAllSceneFactory: CollectThemAllSceneFactory {

    let interface = CapturingCollectThemAllScene()
    func makeCollectThemAllScene() -> UIViewController & CollectThemAllScene {
        return interface
    }

}
