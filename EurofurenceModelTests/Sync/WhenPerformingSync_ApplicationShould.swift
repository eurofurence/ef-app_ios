//
//  WhenPerformingSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenPerformingSync_ApplicationShould: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
    }

    func testTellRefreshServiceObserversRefreshStarted() {
        context.refreshLocalStore()
        XCTAssertEqual(context.refreshObserver.state, .refreshing)
    }

    func testTellRefreshServiceObserversWhenSyncFinishesSuccessfully() {
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)

        XCTAssertEqual(context.refreshObserver.state, .finishedRefreshing)
    }

    func testTellRefreshServiceObserversWhenSyncFails() {
        context.refreshLocalStore()
        context.api.simulateUnsuccessfulSync()

        XCTAssertEqual(context.refreshObserver.state, .finishedRefreshing)
    }

}
