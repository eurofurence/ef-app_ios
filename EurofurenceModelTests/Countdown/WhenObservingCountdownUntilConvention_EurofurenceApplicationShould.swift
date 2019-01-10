//
//  WhenObservingCountdownUntilConvention_EurofurenceApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenObservingCountdownUntilConvention_EurofurenceApplicationShould: XCTestCase {

    func testReturnTheNumberOfDaysBetweenTheClockTimeAndTheConventionStartTime() {
        let observer = CapturingConventionCountdownServiceObserver()
        let clockTime = Date.random
        let context = ApplicationTestBuilder().with(clockTime).build()
        let expected = Int.random
        context.dateDistanceCalculator.stubDistance(between: clockTime, and: context.conventionStartDateRepository.conventionStartDate, with: expected)
        context.conventionCountdownService.add(observer)

        XCTAssertEqual(expected, observer.capturedDaysRemaining)
    }

}
