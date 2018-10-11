//
//  WhenPerformingSubsequentSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenPerformingSubsequentSync_ApplicationShould: XCTestCase {

    func testProvideTheLastSyncTimeToTheSyncAPI() {
        let context = ApplicationTestBuilder().build()
        let expected = Date.random
        context.clock.tickTime(to: expected)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        context.refreshLocalStore()

        XCTAssertEqual(expected, context.syncAPI.capturedLastSyncTime)
    }

    func testCompleteSyncWhenNotRedownloadingAnyImages() {
        let context = ApplicationTestBuilder().build()
        let expected = Date.random
        context.clock.tickTime(to: expected)
        context.refreshLocalStore()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        var didFinishSync = false
        context.refreshLocalStore { (_) in didFinishSync = true }
        context.syncAPI.simulateSuccessfulSync(syncResponse)

        XCTAssertTrue(didFinishSync)
    }

    func testIndicateCompleteProgressIfNothingToDownload() {
        let context = ApplicationTestBuilder().build()
        let expected = Date.random
        context.clock.tickTime(to: expected)
        context.refreshLocalStore()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let progress = context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)

        XCTAssertEqual(1.0, progress.fractionCompleted, accuracy: .ulpOfOne)
    }

}
