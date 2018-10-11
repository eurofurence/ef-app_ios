//
//  WhenObservingRunningEventsBeforeLoadingAnything.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenObservingRunningEventsBeforeLoadingAnything: XCTestCase {

    func testTheObserverIsProvidedWithEmptyEvents() {
        let context = ApplicationTestBuilder().build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)

        XCTAssertTrue(observer.wasProvidedWithEmptyRunningEvents)
    }

}
