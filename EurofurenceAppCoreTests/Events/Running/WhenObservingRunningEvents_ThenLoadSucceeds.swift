//
//  WhenObservingRunningEvents_ThenLoadSucceeds.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenObservingRunningEvents_ThenLoadSucceeds: XCTestCase {

    func testTheObserverIsProvidedWithTheRunningEvents() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = ApplicationTestBuilder().with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.performSuccessfulSync(response: syncResponse)
        let expected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)

        XCTAssertTrue(observer.runningEvents.contains(expected))
    }

}
