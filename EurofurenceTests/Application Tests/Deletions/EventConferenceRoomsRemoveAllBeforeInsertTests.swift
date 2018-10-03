//
//  EventConferenceRoomsRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class EventConferenceRoomsRemoveAllBeforeInsertTests: XCTestCase {
    
    func testTellTheDataStoreToDeleteTheConferenceRooms() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.rooms.removeAllBeforeInsert = true
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        
        XCTAssertEqual(originalResponse.rooms.changed.map({ $0.roomIdentifier }),
                       context.dataStore.transaction.deletedRooms,
                       "Should have removed original days between sync events")
    }
    
}
