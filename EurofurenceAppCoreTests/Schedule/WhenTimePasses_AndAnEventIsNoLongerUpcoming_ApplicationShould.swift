//
//  WhenTimePasses_AndAnEventIsNoLongerUpcoming_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenTimePasses_AndAnEventIsNoLongerUpcoming_ApplicationShould: XCTestCase {

    func testTellTheObserverTheEventIsNoLongerAnUpcomingEvent() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        var simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = ApplicationTestBuilder().with(simulatedTime).build()
        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        simulatedTime = randomEvent.startDateTime.addingTimeInterval(1)
        context.tickTime(to: simulatedTime)

        XCTAssertFalse(observer.upcomingEvents.contains(where: { $0.identifier.rawValue == randomEvent.identifier }))
    }

}
