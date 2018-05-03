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
        let user = User.random
        let loggedInAuthService = FakeAuthenticationService(authState: .loggedIn(user))
        let announcements = [Announcement2].random
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let context = DefaultNewsInteractorTestBuilder().with(loggedInAuthService).with(announcementsService).build()
        context.subscribeViewModelUpdates()
        let expectedUserViewModel = context.makeExpectedUserWidget()
        let expectedAnnouncementViewModels = context.makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements()
        let expected = [expectedUserViewModel] + expectedAnnouncementViewModels
        let expectation = DefaultNewsInteractorTestBuilder.Expectation(components: expected, titles: [.yourEurofurence, .announcements])
        
        context.verify(expectation)
    }
    
}
