//
//  WhenShowingTutorial_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import XCTest

class WhenShowingTutorial_DirectorShould: XCTestCase {

    func testSetTutorialInterfaceOntoNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateTutorialShouldBePresented()

        XCTAssertEqual([context.tutorialModule.stubInterface], context.rootNavigationController.viewControllers)
    }

}
