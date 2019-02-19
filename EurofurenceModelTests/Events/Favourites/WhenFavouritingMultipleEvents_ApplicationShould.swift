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

    private func favouriteEvents(_ identifiers: [EventIdentifier], service: EventsService) {
        let events = identifiers.compactMap(service.fetchEvent)
        events.forEach({ $0.favourite() })
    }

    func testTellEventsObserversTheEventsAreNowFavourited() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let identifiers = events.map({ EventIdentifier($0.identifier) })
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        favouriteEvents(identifiers, service: context.eventsService)

        XCTAssertTrue(identifiers.contains(elementsFrom: observer.capturedFavouriteEventIdentifiers))
    }

    func testTellEventsObserversWhenOnlyOneEventHasBeenUnfavourited() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let identifiers = events.map({ EventIdentifier($0.identifier) })
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        favouriteEvents(identifiers, service: context.eventsService)
        let randomIdentifier = identifiers.randomElement()
        let event = context.eventsService.fetchEvent(identifier: randomIdentifier.element)
        event?.unfavourite()
        var expected = identifiers
        expected.remove(at: randomIdentifier.index)

        XCTAssertTrue(expected.contains(elementsFrom: observer.capturedFavouriteEventIdentifiers))
    }

    func testSortTheFavouriteIdentifiersByEventStartTime() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingDataStore()
        dataStore.performTransaction { (transaction) in
            events.map({ EventIdentifier($0.identifier) }).forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        let expected = events.sorted(by: { $0.startDateTime < $1.startDateTime }).map({ EventIdentifier($0.identifier) })

        XCTAssertTrue(expected.contains(elementsFrom: observer.capturedFavouriteEventIdentifiers))
    }

}
