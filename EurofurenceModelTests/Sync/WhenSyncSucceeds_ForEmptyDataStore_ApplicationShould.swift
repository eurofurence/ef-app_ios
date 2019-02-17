//
//  WhenSyncSucceeds_ForEmptyDataStore_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 05/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSyncSucceeds_ForEmptyDataStore_ApplicationShould: XCTestCase {

    func testSaveAllCharacteristicsIntoTheStore() {
        let context = ApplicationTestBuilder().build()
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let store = context.dataStore

        context.performSuccessfulSync(response: characteristics)

        XCTAssertTrue(store.didSave(characteristics.knowledgeGroups.changed))
        XCTAssertTrue(store.didSave(characteristics.knowledgeEntries.changed))
        XCTAssertTrue(store.didSave(characteristics.announcements.changed))
        XCTAssertTrue(store.didSave(characteristics.events.changed))
        XCTAssertTrue(store.didSave(characteristics.rooms.changed))
        XCTAssertTrue(store.didSave(characteristics.tracks.changed))
        XCTAssertTrue(store.didSave(characteristics.dealers.changed))
        XCTAssertTrue(store.didSave(characteristics.maps.changed))
    }

}
