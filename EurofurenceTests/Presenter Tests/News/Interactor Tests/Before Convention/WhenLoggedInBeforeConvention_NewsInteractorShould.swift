//
//  WhenLoggedInBeforeConvention_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggedInBeforeConvention_NewsInteractorShould: XCTestCase {
    
    func testProduceViewModelWithMessagesPrompt_DaysUntilConvention_AndAnnouncements() {
        let context = DefaultNewsInteractorTestBuilder()
            .with(FakeAuthenticationService.loggedInService())
            .with(StubAnnouncementsService(announcements: .random))
            .build()
        context.subscribeViewModelUpdates()
        
        context.makeAssertion()
            .thatViewModel()
            .appendYourEurofurence()
            .appendConventionCountdown()
            .appendAnnouncements()
            .verify()
    }
    
}
