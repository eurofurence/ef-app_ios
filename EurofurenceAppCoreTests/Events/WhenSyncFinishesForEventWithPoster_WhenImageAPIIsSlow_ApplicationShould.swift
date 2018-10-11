//
//  WhenSyncFinishesForEventWithPoster_WhenImageAPIIsSlow_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenSyncFinishesForEventWithPoster_WhenImageAPIIsSlow_ApplicationShould: XCTestCase {

    func testStillAdaptTheFetchedDataIntoTheEvent() {
        let imageAPI = SlowFakeImageAPI()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = ApplicationTestBuilder().with(imageAPI).with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.performSuccessfulSync(response: syncResponse)
        imageAPI.resolvePendingFetches()
        let expected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)

        XCTAssertTrue(observer.runningEvents.contains(expected))
    }

}
