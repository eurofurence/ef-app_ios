//
//  WhenPerformingSyncThatFails.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenPerformingSyncThatFails: XCTestCase {

    func testTheCompletionHandlerIsInvokedWithAnError() {
        let context = EurofurenceSessionTestBuilder().build()
        var error: Error?
        context.refreshLocalStore { error = $0 }
        context.api.simulateUnsuccessfulSync()

        XCTAssertNotNil(error)
    }

    func testTheLongRunningTaskManagerIsToldToEndTaskBeganAtStartOfSync() {
        let context = EurofurenceSessionTestBuilder().build()
        context.refreshLocalStore()
        context.api.simulateUnsuccessfulSync()

        XCTAssertTrue(context.longRunningTaskManager.finishedTask)
    }

}
