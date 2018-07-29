//
//  WhenSyncSucceedsWithChangedImages_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSyncSucceedsWithChangedImages_ApplicationShould: XCTestCase {
    
    func testSaveTheImagesIntoTheStore() {
        let dataStore = CapturingEurofurenceDataStore()
        let context = ApplicationTestBuilder().with(dataStore).build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        XCTAssertTrue(dataStore.didSave(syncResponse.images.changed))
    }
    
}
