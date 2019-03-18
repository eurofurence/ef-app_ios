//
//  EventConferenceTracksRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class EventConferenceTracksRemoveAllBeforeInsertTests: XCTestCase {

    func testTellTheDataStoreToDeleteTheTracks() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.tracks.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(subsequentResponse.tracks.changed,
                       context.dataStore.fetchTracks(),
                       "Should have removed original tracks between sync events")
    }

}
