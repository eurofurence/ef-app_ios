//
//  WhenSyncSucceedsWithChangedImages_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSyncSucceedsWithChangedImages_ApplicationShould: XCTestCase {

    func testSaveTheImagesIntoTheStore() {
        let dataStore = FakeDataStore()
        let context = ApplicationTestBuilder().with(dataStore).build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertTrue(dataStore.didSave(syncResponse.images.changed))
    }

}
