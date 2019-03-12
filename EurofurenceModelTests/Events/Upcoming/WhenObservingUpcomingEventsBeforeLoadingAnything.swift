//
//  WhenObservingUpcomingEventsBeforeLoadingAnything.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenObservingUpcomingEventsBeforeLoadingAnything: XCTestCase {

    func testTheObserverIsProvidedWithEmptyUpcomingEvents() {
        let context = EurofurenceSessionTestBuilder().build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        XCTAssertTrue(observer.wasProvidedWithEmptyUpcomingEvents)
    }

}
