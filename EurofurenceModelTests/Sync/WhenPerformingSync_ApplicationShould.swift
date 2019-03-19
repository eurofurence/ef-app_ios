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
    var refreshObserver: CapturingRefreshServiceObserver!

    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
        refreshObserver = CapturingRefreshServiceObserver()
        context.refreshService.add(refreshObserver)
    }

    func testTellRefreshServiceObserversRefreshStarted() {
        context.refreshLocalStore()
        XCTAssertEqual(refreshObserver.state, .refreshing)
    }

    func testTellRefreshServiceObserversWhenSyncFinishesSuccessfully() {
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)

        XCTAssertEqual(refreshObserver.state, .finishedRefreshing)
    }

    func testTellRefreshServiceObserversWhenSyncFails() {
        context.refreshLocalStore()
        context.api.simulateUnsuccessfulSync()

        XCTAssertEqual(refreshObserver.state, .finishedRefreshing)
    }

}
