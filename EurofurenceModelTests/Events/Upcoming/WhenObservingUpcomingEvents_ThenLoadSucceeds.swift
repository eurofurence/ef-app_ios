//
//  WhenObservingUpcomingEvents_ThenLoadSucceeds.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenObservingUpcomingEvents_ThenLoadSucceeds: XCTestCase {

    func testTheObserverIsProvidedWithTheUpcomingEvents() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = ApplicationTestBuilder().with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.performSuccessfulSync(response: syncResponse)
        let expected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)

        XCTAssertTrue(observer.upcomingEvents.contains(expected))
    }

    func testTheObserverIsNotProvidedWithEventsThatHaveBegan() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = ApplicationTestBuilder().with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        let expectedEvents = syncResponse.events.changed.filter { (event) -> Bool in
            return event.startDateTime > simulatedTime
        }

        let expected = expectedEvents.map { (event) -> Event in
            return context.makeExpectedEvent(from: event, response: syncResponse)
        }

        XCTAssertEqual(expected, observer.upcomingEvents)
    }

    func testTheObserverIsNotProvidedWithEventsTooFarIntoTheFuture() {
        let timeIntervalForUpcomingEventsSinceNow: TimeInterval = .random
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-timeIntervalForUpcomingEventsSinceNow - 1)
        let context = ApplicationTestBuilder().with(simulatedTime).with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        let unexpected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)

        XCTAssertFalse(observer.upcomingEvents.contains(unexpected))
    }

    func testEventsThatHaveJustStartedAreNotConsideredUpcoming() {
        let timeIntervalForUpcomingEventsSinceNow: TimeInterval = .random
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = ApplicationTestBuilder().with(simulatedTime).with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        let unexpected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)

        XCTAssertFalse(observer.upcomingEvents.contains(unexpected))
    }

}
