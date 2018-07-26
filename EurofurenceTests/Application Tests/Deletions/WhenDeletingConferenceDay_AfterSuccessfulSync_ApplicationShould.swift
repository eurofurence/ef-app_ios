//
//  WhenDeletingConferenceDay_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenDeletingConferenceDay_AfterSuccessfulSync_ApplicationShould: XCTestCase {
    
    func testTellTheStoreToDeleteTheDay() {
        let dataStore = CapturingEurofurenceDataStore()
        var response = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let dayToDelete = String.random
        response.conferenceDays.deleted = [dayToDelete]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        
        XCTAssertEqual([dayToDelete], dataStore.transaction.deletedConferenceDays)
    }
    
}
