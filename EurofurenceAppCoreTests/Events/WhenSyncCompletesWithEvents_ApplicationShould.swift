//
//  WhenSyncCompletesWithEvents_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSyncCompletesWithEvents_ApplicationShould: XCTestCase {

    func testTellObserversAboutAvailableEvents() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.performSuccessfulSync(response: syncResponse)
        let expected = context.makeExpectedEvents(from: syncResponse.events.changed, response: syncResponse)

        XCTAssertEqual(expected, observer.allEvents)
    }

}
