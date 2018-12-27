//
//  StubMapsSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import UIKit

class StubMapsSceneFactory: MapsSceneFactory {

    let scene = CapturingMapsScene()
    func makeMapsScene() -> UIViewController & MapsScene {
        return scene
    }

}
