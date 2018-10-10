//
//  WhenObservingUpcomingEventsBeforeLoadingAnything.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenObservingUpcomingEventsBeforeLoadingAnything: XCTestCase {
    
    func testTheObserverIsProvidedWithEmptyUpcomingEvents() {
        let context = ApplicationTestBuilder().build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        
        XCTAssertTrue(observer.wasProvidedWithEmptyUpcomingEvents)
    }
    
}
