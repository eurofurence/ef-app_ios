//
//  WhenSyncSuceeds_ThenObservingUpcomingEvents.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSyncSuceeds_ThenObservingUpcomingEvents: XCTestCase {

    func testTheObserverIsProvidedWithTheUpcomingEvents() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = ApplicationTestBuilder().with(simulatedTime).build()
        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        let expected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)

        XCTAssertTrue(observer.upcomingEvents.contains(expected))
    }

}
