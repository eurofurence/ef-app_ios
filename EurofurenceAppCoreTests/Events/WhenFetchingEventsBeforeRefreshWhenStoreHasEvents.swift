//
//  WhenFetchingEventsBeforeRefreshWhenStoreHasEvents.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 05/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenFetchingEventsBeforeRefreshWhenStoreHasEvents: XCTestCase {

    func testTheEventsFromTheStoreAreAdapted() {
        let dataStore = CapturingEurofurenceDataStore()
        let response = APISyncResponse.randomWithoutDeletions
        dataStore.performTransaction { (transaction) in
            transaction.saveRooms(response.rooms.changed)
            transaction.saveEvents(response.events.changed)
            transaction.saveTracks(response.tracks.changed)
        }

        let imageRepository = CapturingImageRepository()
        let bannerIdentifiers = response.events.changed.compactMap({ $0.bannerImageId })
        let posterIdentifiers = response.events.changed.compactMap({ $0.posterImageId })
        imageRepository.stub(identifiers: bannerIdentifiers + posterIdentifiers)

        let context = ApplicationTestBuilder().with(dataStore).with(imageRepository).build()
        let expected = context.makeExpectedEvents(from: response.events.changed, response: response)

        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)

        XCTAssertEqual(expected, observer.allEvents)
    }

}
