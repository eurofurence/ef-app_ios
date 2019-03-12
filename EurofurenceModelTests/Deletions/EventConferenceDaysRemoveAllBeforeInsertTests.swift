//
//  EventConferenceDaysRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class EventConferenceDaysRemoveAllBeforeInsertTests: XCTestCase {

    func testTellTheDataStoreToDeleteTheConferenceDays() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.conferenceDays.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(originalResponse.conferenceDays.changed.map({ $0.identifier }),
                       context.dataStore.transaction.deletedConferenceDays,
                       "Should have removed original days between sync events")
    }

}
