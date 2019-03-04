//
//  WhenPreloadCompletes_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenPreloadCompletes_DirectorShould: XCTestCase {

    func testShowTheTabModuleUsingDissolveTransition() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateTutorialShouldBePresented()
        context.tutorialModule.simulateTutorialFinished()
        context.preloadModule.simulatePreloadFinished()

        let navigationController = context.rootNavigationController
        let preloadModule = context.preloadModule.stubInterface
        let tabModule = context.tabModule.stubInterface
        let transition = navigationController.delegate?.navigationController?(navigationController, animationControllerFor: .push, from: preloadModule, to: tabModule)

        XCTAssertEqual([context.tabModule.stubInterface], context.rootNavigationController.viewControllers)
        XCTAssertTrue(transition is ViewControllerDissolveTransitioning)
    }

}
