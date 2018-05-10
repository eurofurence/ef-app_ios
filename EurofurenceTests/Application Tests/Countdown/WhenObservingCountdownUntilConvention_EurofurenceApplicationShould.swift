//
//  WhenObservingCountdownUntilConvention_EurofurenceApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenObservingCountdownUntilConvention_EurofurenceApplicationShould: XCTestCase {
    
    func testReturnTheNumberOfDaysBetweenTheClockTimeAndTheConventionStartTime() {
        let observer = CapturingDaysUntilConventionServiceObserver()
        let clockTime = Date.random
        let context = ApplicationTestBuilder().with(clockTime).build()
        let expected = Int.random
        context.dateDistanceCalculator.stubDistance(between: clockTime, and: context.conventionStartDateRepository.conventionStartDate, with: expected)
        context.application.observeDaysUntilConvention(using: observer)
        
        XCTAssertEqual(expected, observer.capturedDaysRemaining)
    }
    
}
