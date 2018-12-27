//
//  WhenTheTutorialAppears.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenTheTutorialAppears: XCTestCase {

    var context: TutorialModuleTestBuilder.Context!

    override func setUp() {
        super.setUp()
        context = TutorialModuleTestBuilder().build()
    }

    func testItShouldBeToldToShowTheTutorialPage() {
        XCTAssertTrue(context.tutorial.wasToldToShowTutorialPage)
    }

    func testItShouldReturnTheViewControllerFromTheFactory() {
        XCTAssertEqual(context.tutorialViewController, context.tutorial)
    }

}
