//
//  WhenDeletingRoom_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenDeletingRoom_AfterSuccessfulSync_ApplicationShould: XCTestCase {
    
    func testTellTheStoreToDeleteTheRoom() {
        let dataStore = CapturingEurofurenceDataStore()
        var response = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let roomToDelete = String.random
        response.rooms.deleted = [roomToDelete]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        
        XCTAssertEqual([roomToDelete], dataStore.transaction.deletedRooms)
    }
    
}
