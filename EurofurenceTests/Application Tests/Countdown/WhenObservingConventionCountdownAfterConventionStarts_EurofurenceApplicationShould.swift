//
//  WhenObservingConventionCountdownAfterConventionStarts_EurofurenceApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class WhenObservingConventionCountdownAfterConventionStarts_EurofurenceApplicationShould: XCTestCase {
    
    func testTellObserverTheCountdownElapsed() {
        let observer = CapturingConventionCountdownServiceObserver()
        let clockTime = Date.random
        let context = ApplicationTestBuilder().with(clockTime).build()
        let distanceToImplyConventionHasStarted = 0
        context.dateDistanceCalculator.stubDistance(between: clockTime,
                                                    and: context.conventionStartDateRepository.conventionStartDate,
                                                    with: distanceToImplyConventionHasStarted)
        context.application.add(observer)
        
        XCTAssertTrue(observer.toldCountdownDidElapse)
    }
    
}
