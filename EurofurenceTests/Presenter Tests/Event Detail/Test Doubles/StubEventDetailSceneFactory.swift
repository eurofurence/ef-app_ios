//
//  StubEventDetailSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import UIKit.UIViewController

class StubEventDetailSceneFactory: EventDetailSceneFactory {
    
    let interface = CapturingEventDetailScene()
    func makeEventDetailScene() -> UIViewController & EventDetailScene {
        return interface
    }
    
}
