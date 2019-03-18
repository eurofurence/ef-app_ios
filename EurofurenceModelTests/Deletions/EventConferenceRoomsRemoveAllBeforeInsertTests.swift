//
//  EventConferenceRoomsRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class EventConferenceRoomsRemoveAllBeforeInsertTests: XCTestCase {

    func testTellTheDataStoreToDeleteTheConferenceRooms() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.rooms.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(subsequentResponse.rooms.changed, context.dataStore.fetchRooms(),
                       "Should have removed original rooms between sync events")
    }

}
