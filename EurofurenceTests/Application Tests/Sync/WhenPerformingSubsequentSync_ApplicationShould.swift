//
//  WhenPerformingSubsequentSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPerformingSubsequentSync_ApplicationShould: XCTestCase {
    
    func testProvideTheLastSyncTimeToTheSyncAPI() {
        let context = ApplicationTestBuilder().build()
        let expected = Date.random
        context.clock.currentDate = expected
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        context.refreshLocalStore()
        
        XCTAssertEqual(expected, context.syncAPI.capturedLastSyncTime)
    }
    
    func testNotRedownloadAlreadyDownloadedImages() {
        let context = ApplicationTestBuilder().build()
        let expected = Date.random
        context.clock.currentDate = expected
        context.refreshLocalStore()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        context.refreshLocalStore()
        let downloadedImages = context.imageAPI.downloadedImageIdentifiers
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        XCTAssertEqual(downloadedImages, context.imageAPI.downloadedImageIdentifiers)
    }
    
}
