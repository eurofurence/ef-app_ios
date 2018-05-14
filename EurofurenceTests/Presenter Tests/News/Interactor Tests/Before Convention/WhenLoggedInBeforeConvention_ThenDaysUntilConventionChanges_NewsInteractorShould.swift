//
//  WhenLoggedInBeforeConvention_ThenDaysUntilConventionChanges_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggedInBeforeConvention_ThenDaysUntilConventionChanges_NewsInteractorShould: XCTestCase {
    
    func testUpdateTheCountdownWidget() {
        let countdownService = StubConventionCountdownService()
        let context = DefaultNewsInteractorTestBuilder()
            .with(FakeAuthenticationService.loggedInService())
            .with(countdownService)
            .build()
        context.subscribeViewModelUpdates()
        let daysUntilConvention = Int.random
        countdownService.changeDaysUntilConvention(to: daysUntilConvention)
        
        context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }
    
}
