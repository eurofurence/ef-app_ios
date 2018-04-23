//
//  StubEventsSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubEventsSceneFactory: EventsSceneFactory {
    
    let scene = CapturingEventsScene()
    func makeEventsScene() -> UIViewController & EventsScene {
        return scene
    }
    
}
