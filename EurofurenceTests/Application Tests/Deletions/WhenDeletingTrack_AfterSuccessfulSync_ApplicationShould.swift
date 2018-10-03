//
//  WhenDeletingTrack_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class WhenDeletingTrack_AfterSuccessfulSync_ApplicationShould: XCTestCase {
    
    func testTellTheStoreToDeleteTheTrack() {
        let dataStore = CapturingEurofurenceDataStore()
        var response = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let trackToDelete = String.random
        response.tracks.deleted = [trackToDelete]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        
        XCTAssertEqual([trackToDelete], dataStore.transaction.deletedTracks)
    }
    
}
