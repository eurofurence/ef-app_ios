//
//  WhenFavouritingEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFavouritingEvent_ApplicationShould: XCTestCase {

    var context: ApplicationTestBuilder.Context!
    var events: [EventCharacteristics]!

    override func setUp() {
        super.setUp()

        let response = ModelCharacteristics.randomWithoutDeletions
        events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }

        context = ApplicationTestBuilder().with(dataStore).build()
    }

    func testTellTheDataStoreToSaveTheEventIdentifier() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        context.eventsService.favouriteEvent(identifier: identifier)

        XCTAssertTrue(context.dataStore.didFavouriteEvent(identifier))
    }

    func testTellEventsObserversTheEventIsNowFavourited() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        context.eventsService.favouriteEvent(identifier: identifier)

        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

    func testTellLateAddedObserversAboutTheFavouritedEvent() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.favouriteEvent(identifier: identifier)
        context.eventsService.add(observer)

        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

    func testOrganiseTheFavouritesInStartTimeOrder() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let storedFavourites = events.map({ EventIdentifier($0.identifier) })
        storedFavourites.filter({ $0 != identifier }).forEach(context.eventsService.favouriteEvent)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        context.eventsService.favouriteEvent(identifier: identifier)
        let expected = events.sorted(by: { $0.startDateTime < $1.startDateTime }).map({ EventIdentifier($0.identifier) })

        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }

    func testScheduleReminderForEvent() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        context.eventsService.favouriteEvent(identifier: identifier)

        XCTAssertEqual(identifier, context.notificationScheduler.capturedEventIdentifier)
    }

}
