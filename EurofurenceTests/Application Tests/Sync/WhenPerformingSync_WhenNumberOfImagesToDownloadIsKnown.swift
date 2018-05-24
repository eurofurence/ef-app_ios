//
//  WhenPerformingSync_WhenNumberOfImagesToDownloadIsKnown.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPerformingSync_WhenNumberOfImagesToDownloadIsKnown: XCTestCase {
    
    func testTheTotalUnitCountIsUpdatedWithTheNumberOfImagesToAcquire() {
        let imageAPI = SlowFakeImageAPI()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().with(imageAPI).build()
        let progress = context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        XCTAssertEqual(imageAPI.numberOfPendingFetches, Int(progress.totalUnitCount))
    }
    
}
