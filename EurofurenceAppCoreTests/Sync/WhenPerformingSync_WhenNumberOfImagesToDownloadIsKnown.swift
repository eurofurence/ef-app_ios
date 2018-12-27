//
//  WhenPerformingSync_WhenNumberOfImagesToDownloadIsKnown.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenPerformingSync_WhenNumberOfImagesToDownloadIsKnown: XCTestCase {

    var imageAPI: SlowFakeImageAPI!
    var context: ApplicationTestBuilder.Context!
    var progress: Progress!

    override func setUp() {
        super.setUp()

        imageAPI = SlowFakeImageAPI()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context = ApplicationTestBuilder().with(imageAPI).build()
        progress = context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
    }

    func testTheTotalUnitCountIsUpdatedWithTheNumberOfImagesToAcquire() {
        XCTAssertEqual(imageAPI.numberOfPendingFetches, Int(progress.totalUnitCount))
    }

    func testTheCompletedUnitCountIsIncrementedWheneverAnImageIsDownloaded() {
        let randomAmountOfImagesToComplete = Int.random(upperLimit: UInt32(imageAPI.numberOfPendingFetches))
        (0..<randomAmountOfImagesToComplete).forEach { (_) in imageAPI.resolveNextFetch() }

        XCTAssertEqual(randomAmountOfImagesToComplete, Int(progress.completedUnitCount))
    }

}
