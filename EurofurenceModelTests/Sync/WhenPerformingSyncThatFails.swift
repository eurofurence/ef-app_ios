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

    func testTheCompletionHandlerIsInvokedWithNetworkError() {
        let context = EurofurenceSessionTestBuilder().build()
        var error: RefreshServiceError?
        context.refreshLocalStore { error = $0 }
        context.api.simulateUnsuccessfulSync()

        XCTAssertEqual(RefreshServiceError.apiError, error)
    }

    func testTheLongRunningTaskManagerIsToldToEndTaskBeganAtStartOfSync() {
        let context = EurofurenceSessionTestBuilder().build()
        context.refreshLocalStore()
        context.api.simulateUnsuccessfulSync()

        XCTAssertEqual(context.longRunningTaskManager.state, .ended)
    }

}
