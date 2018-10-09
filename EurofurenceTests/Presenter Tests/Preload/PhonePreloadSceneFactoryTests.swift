//
//  PhonePreloadSceneFactoryTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class PhonePreloadSceneFactoryTests: XCTestCase {
    
    func testThePreloadSceneViewControllerIsMade() {
        let factory = PhonePreloadSceneFactory()
        let scene = factory.makePreloadScene()
        
        XCTAssertNotNil(scene.storyboard)
    }
    
}
