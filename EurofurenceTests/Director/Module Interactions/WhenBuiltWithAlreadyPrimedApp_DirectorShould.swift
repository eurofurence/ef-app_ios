//
//  WhenBuiltWithAlreadyPrimedApp_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBuiltWithAlreadyPrimedApp_DirectorShould: XCTestCase {
    
    func testShowTheTabModuleUsingDissolveTransition() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateAppReady()
        let transition = context.rootNavigationController.delegate?.navigationController?(context.rootNavigationController, animationControllerFor: .push, from: context.preloadModule.stubInterface, to: context.tabModule.stubInterface)
        
        XCTAssertEqual([context.tabModule.stubInterface], context.rootNavigationController.viewControllers)
        XCTAssertTrue(transition is ViewControllerDissolveTransitioning)
    }
    
}
