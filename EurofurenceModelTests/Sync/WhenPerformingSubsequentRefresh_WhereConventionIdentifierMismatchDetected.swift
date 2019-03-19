//
//  WhenPerformingSubsequentRefresh_WhereConventionIdentifierMismatchDetected.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenPerformingSubsequentRefresh_WhereConventionIdentifierMismatchDetected: XCTestCase {

    func testTheStoreRemainsUnchanged() {
        let context = EurofurenceSessionTestBuilder().build()
        let first = ModelCharacteristics.randomWithoutDeletions
        var second = ModelCharacteristics.randomWithoutDeletions
        second.conventionIdentifier = .random
        context.performSuccessfulSync(response: first)
        context.performSuccessfulSync(response: second)
        
        let store = context.dataStore
        
        XCTAssertEqual(first.knowledgeGroups.changed, store.fetchKnowledgeGroups())
        XCTAssertEqual(first.knowledgeEntries.changed, store.fetchKnowledgeEntries())
        XCTAssertEqual(first.announcements.changed, store.fetchAnnouncements())
        XCTAssertEqual(first.events.changed, store.fetchEvents())
        XCTAssertEqual(first.rooms.changed, store.fetchRooms())
        XCTAssertEqual(first.tracks.changed, store.fetchTracks())
        XCTAssertEqual(first.conferenceDays.changed, store.fetchConferenceDays())
        XCTAssertEqual(first.dealers.changed, store.fetchDealers())
        XCTAssertEqual(first.maps.changed, store.fetchMaps())
        XCTAssertEqual(first.images.changed, store.fetchImages())
    }

}
