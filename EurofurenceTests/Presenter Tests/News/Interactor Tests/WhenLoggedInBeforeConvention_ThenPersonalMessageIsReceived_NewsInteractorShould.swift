//
//  WhenLoggedInBeforeConvention_ThenPersonalMessageIsReceived_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggedInBeforeConvention_ThenPersonalMessageIsReceived_NewsInteractorShould: XCTestCase {
    
    func testProduceViewModelWithMessagesPrompt_DaysUntilConvention_AndAnnouncements() {
        let privateMessagesService = CapturingPrivateMessagesService()
        let context = DefaultNewsInteractorTestBuilder()
            .with(FakeAuthenticationService.loggedInService())
            .with(StubAnnouncementsService(announcements: .random))
            .with(privateMessagesService)
            .build()
        context.subscribeViewModelUpdates()
        let unreadCount = Int.random
        privateMessagesService.notifyUnreadCountDidChange(to: unreadCount)
        let expected = [context.makeExpectedUserWidget(), context.makeDaysUntilConventionWidget()] + context.makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements()
        let expectation = DefaultNewsInteractorTestBuilder.Expectation(components: expected, titles: [.yourEurofurence, .daysUntilConvention, .announcements])
        
        context.verify(expectation)
    }
    
}
