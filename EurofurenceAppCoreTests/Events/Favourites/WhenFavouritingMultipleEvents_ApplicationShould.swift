//
//  WhenFavouritingMultipleEvents_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFavouritingMultipleEvents_ApplicationShould: XCTestCase {

    func testTellEventsObserversTheEventsAreNowFavourited() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let identifiers = events.map({ Event.Identifier($0.identifier) })
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        identifiers.forEach(context.application.favouriteEvent)

        XCTAssertTrue(identifiers.contains(elementsFrom: observer.capturedFavouriteEventIdentifiers))
    }

    func testTellEventsObserversWhenOnlyOneEventHasBeenUnfavourited() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let identifiers = events.map({ Event.Identifier($0.identifier) })
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        identifiers.forEach(context.application.favouriteEvent)
        let randomIdentifier = identifiers.randomElement()
        context.application.unfavouriteEvent(identifier: randomIdentifier.element)
        var expected = identifiers
        expected.remove(at: randomIdentifier.index)

        XCTAssertTrue(expected.contains(elementsFrom: observer.capturedFavouriteEventIdentifiers))
    }

    func testSortTheFavouriteIdentifiersByEventStartTime() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            events.map({ Event.Identifier($0.identifier) }).forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)

        let expected = events.sorted(by: { $0.startDateTime < $1.startDateTime }).map({ Event.Identifier($0.identifier) })

        XCTAssertTrue(expected.contains(elementsFrom: observer.capturedFavouriteEventIdentifiers))
    }

}
