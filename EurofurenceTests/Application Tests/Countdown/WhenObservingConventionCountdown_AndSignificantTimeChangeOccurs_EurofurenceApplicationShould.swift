//
//  WhenObservingConventionCountdown_AndSignificantTimeChangeOccurs_EurofurenceApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenObservingConventionCountdown_AndSignificantTimeChangeOccurs_EurofurenceApplicationShould: XCTestCase {
    
    func testUpdateTheObserversWithTheNewCountdownInterval() {
        let observer = CapturingDaysUntilConventionServiceObserver()
        let clockTime = Date.random
        let context = ApplicationTestBuilder().with(clockTime).build()
        var expected: Int = .random
        context.dateDistanceCalculator.stubDistance(between: clockTime, and: context.conventionStartDateRepository.conventionStartDate, with: expected)
        context.application.observeDaysUntilConvention(using: observer)
        expected = .random
        context.dateDistanceCalculator.stubDistance(between: clockTime, and: context.conventionStartDateRepository.conventionStartDate, with: expected)
        context.significantTimeChangeEventSource.simulateSignificantTimeChange()
        
        XCTAssertEqual(expected, observer.capturedDaysRemaining)
    }
    
}
