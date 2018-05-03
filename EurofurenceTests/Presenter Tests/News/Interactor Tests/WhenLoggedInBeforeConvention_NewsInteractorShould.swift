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
    
    func testProduceViewModelWithMessagesPrompt_AndAnnouncements() {
        let context = DefaultNewsInteractorTestBuilder()
            .with(FakeAuthenticationService.loggedInService())
            .with(StubAnnouncementsService(announcements: .random))
            .build()
        context.subscribeViewModelUpdates()
        let expected = [context.makeExpectedUserWidget()] + context.makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements()
        let expectation = DefaultNewsInteractorTestBuilder.Expectation(components: expected, titles: [.yourEurofurence, .announcements])
        
        context.verify(expectation)
    }
    
}
