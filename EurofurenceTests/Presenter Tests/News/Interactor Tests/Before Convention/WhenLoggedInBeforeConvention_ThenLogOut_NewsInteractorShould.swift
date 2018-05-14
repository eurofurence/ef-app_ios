//
//  WhenLoggedInBeforeConvention_ThenLogOut_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggedInBeforeConvention_ThenLogOut_NewsInteractorShould: XCTestCase {
    
    func testUpdateTheDelegateWithLoggedOutUserWidget() {
        let authenticationService = FakeAuthenticationService.loggedInService()
        let context = DefaultNewsInteractorTestBuilder()
            .with(StubAnnouncementsService(announcements: .random))
            .with(authenticationService)
            .build()
        context.subscribeViewModelUpdates()
        authenticationService.notifyObserversUserDidLogout()
        
        context.makeAssertion()
            .thatViewModel()
            .appendYourEurofurence()
            .appendConventionCountdown()
            .appendAnnouncements()
            .verify()
    }
    
}
