//
//  WhenDeletingRoom_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDeletingRoom_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testTellTheStoreToDeleteTheRoom() {
        let dataStore = FakeDataStore()
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = ApplicationTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let roomToDelete = String.random
        response.rooms.deleted = [roomToDelete]
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)

        XCTAssertEqual([roomToDelete], dataStore.transaction.deletedRooms)
    }

}
