//
//  StubNavigationControllerFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit.UINavigationController

struct StubNavigationControllerFactory: NavigationControllerFactory {
    
    func makeNavigationController() -> UINavigationController {
        return CapturingNavigationController()
    }
    
}
