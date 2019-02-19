//
//  WhenUnfavouritingEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenUnfavouritingEvent_ApplicationShould: XCTestCase {

    var context: ApplicationTestBuilder.Context!
    var identifier: EventIdentifier!
    var observer: CapturingEventsServiceObserver!

    override func setUp() {
        super.setUp()

        context = ApplicationTestBuilder().build()
        let modelCharacteristics = ModelCharacteristics.randomWithoutDeletions
        observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        let randomEvent = modelCharacteristics.events.changed.randomElement().element
        context.performSuccessfulSync(response: modelCharacteristics)

        identifier = EventIdentifier(randomEvent.identifier)
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.favourite()
        event?.unfavourite()
    }

    func testTellTheDataStoreToDeleteTheEventIdentifier() {
        XCTAssertTrue(context.dataStore.didDeleteFavouriteEvent(identifier))
    }

    func testTellObserversTheEventHasBeenUnfavourited() {
        XCTAssertFalse(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

    func testTellTheNotificationServiceToRemoveTheScheduledNotification() {
        XCTAssertEqual(identifier, context.notificationScheduler.capturedEventIdentifierToRemoveNotification)
    }

}
