//
//  EventConferenceTracksRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class EventConferenceTracksRemoveAllBeforeInsertTests: XCTestCase {
    
    func testTellTheDataStoreToDeleteTheTracks() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.tracks.removeAllBeforeInsert = true
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        
        XCTAssertEqual(originalResponse.tracks.changed.map({ $0.trackIdentifier }),
                       context.dataStore.transaction.deletedTracks,
                       "Should have removed original days between sync events")
    }
    
}
