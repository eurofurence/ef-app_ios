//
//  StubDealersSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit.UIViewController

class StubDealersSceneFactory: DealersSceneFactory {

    let scene = CapturingDealersScene()
    func makeDealersScene() -> UIViewController & DealersScene {
        return scene
    }

}
