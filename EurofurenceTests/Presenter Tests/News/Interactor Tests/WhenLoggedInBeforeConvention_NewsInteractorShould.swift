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
        let delegate = VerifyingNewsInteractorDelegate()
        context.interactor.subscribeViewModelUpdates(delegate)
        let expectedUserViewModel = UserWidgetComponentViewModel(prompt: String.welcomePrompt(for: user),
                                                                 detailedPrompt: String.welcomeDescription(messageCount: 0),
                                                                 hasUnreadMessages: false)
        let expectedAnnouncementViewModels = context.makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements()
        let expected = [AnyHashable(expectedUserViewModel)] + expectedAnnouncementViewModels
        let expectation = VerifyingNewsInteractorDelegate.Expectation(components: expected, titles: [.yourEurofurence, .announcements])
        
        delegate.verify(expectation)
    }
    
}
