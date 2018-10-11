//
//  WhenPreloadFails_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import XCTest

class WhenPreloadFails_DirectorShould: XCTestCase {

    func testShowTheTutorial() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateTutorialShouldBePresented()
        context.tutorialModule.simulateTutorialFinished()
        context.preloadModule.simulatePreloadCancelled()

        XCTAssertEqual([context.tutorialModule.stubInterface], context.rootNavigationController.viewControllers)
    }

}
