//
//  WhenViewingMessagesWhenLoggedIn_BeforeSceneAppears.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenViewingMessagesWhenLoggedIn_BeforeSceneAppears: XCTestCase {

    func testTheSceneIsNotToldToShowTheRefreshIndicator() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertFalse(context.scene.wasToldToShowRefreshIndicator)
    }

}
