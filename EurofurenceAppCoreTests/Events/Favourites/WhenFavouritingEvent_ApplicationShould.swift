//
//  WhenFavouritingEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenFavouritingEvent_ApplicationShould: XCTestCase {

    var context: ApplicationTestBuilder.Context!
    var events: [APIEvent]!

    override func setUp() {
        super.setUp()

        let response = APISyncResponse.randomWithoutDeletions
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
        let identifier = Event.Identifier(events.randomElement().element.identifier)
        context.application.favouriteEvent(identifier: identifier)

        XCTAssertTrue(context.dataStore.didFavouriteEvent(identifier))
    }

    func testTellEventsObserversTheEventIsNowFavourited() {
        let identifier = Event.Identifier(events.randomElement().element.identifier)
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.application.favouriteEvent(identifier: identifier)

        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

    func testTellLateAddedObserversAboutTheFavouritedEvent() {
        let identifier = Event.Identifier(events.randomElement().element.identifier)
        let observer = CapturingEventsServiceObserver()
        context.application.favouriteEvent(identifier: identifier)
        context.application.add(observer)

        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

    func testOrganiseTheFavouritesInStartTimeOrder() {
        let identifier = Event.Identifier(events.randomElement().element.identifier)
        let storedFavourites = events.map({ Event.Identifier($0.identifier) })
        storedFavourites.filter({ $0 != identifier }).forEach(context.application.favouriteEvent)
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.application.favouriteEvent(identifier: identifier)
        let expected = events.sorted(by: { $0.startDateTime < $1.startDateTime }).map({ Event.Identifier($0.identifier) })

        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }

    func testScheduleReminderForEvent() {
        let identifier = Event.Identifier(events.randomElement().element.identifier)
        context.application.favouriteEvent(identifier: identifier)

        XCTAssertEqual(identifier, context.notificationsService.capturedEventIdentifier)
    }

}
