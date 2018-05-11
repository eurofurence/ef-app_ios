//
//  WhenLoggedOutDuringConvention_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggedOutDuringConvention_NewsInteractorShould: XCTestCase {
    
    func testProduceViewModelWithMessagesPrompt_Announcements_RunningEvents_AndUpcomingEvents() {
        let context = DefaultNewsInteractorTestBuilder()
            .with(FakeAuthenticationService.loggedOutService())
            .with(StubAnnouncementsService(announcements: .random))
            .with(StubConventionCountdownService(countdownState: .countdownElapsed))
            .build()
        context.subscribeViewModelUpdates()
        
        context.verifyViewModelForDuringConvention()
    }
    
}
