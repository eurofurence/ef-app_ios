//
//  WhenLoggedOutBeforeConvention_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggedOutBeforeConvention_NewsInteractorShould: XCTestCase {
    
    var context: DefaultNewsInteractorTestBuilder.Context!
    var delegate: VerifyingNewsInteractorDelegate!
    
    override func setUp() {
        super.setUp()
        
        let announcements = [Announcement2].random
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        context = DefaultNewsInteractorTestBuilder()
            .with(announcementsService)
            .with(FakeAuthenticationService(authState: .loggedOut))
            .build()
        delegate = VerifyingNewsInteractorDelegate()
        context.interactor.subscribeViewModelUpdates(delegate)
    }
    
    func testProduceViewModelWithLoginPrompt_AndAnnouncements() {
        let expectedUserViewModel = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                                 detailedPrompt: .anonymousUserLoginDescription,
                                                                 hasUnreadMessages: false)
        let expectedAnnouncementViewModels = context.makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements()
        let expected = [AnyHashable(expectedUserViewModel)] + expectedAnnouncementViewModels
        let expectation = VerifyingNewsInteractorDelegate.Expectation(components: expected, titles: [.yourEurofurence, .announcements])
        
        delegate.verify(expectation)
    }
    
    func testFetchMessagesModuleValueWhenAskingForModelInFirstSection() {
        delegate.verifyModel(at: IndexPath(item: 0, section: 0), is: .messages)
    }
    
    func testFetchAnnouncementModuleValueWhenAskingForModelInSecondSection() {
        let randomAnnouncement = context.announcements.randomElement()
        let announcementIndexPath = IndexPath(item: randomAnnouncement.index, section: 1)
        
        delegate.verifyModel(at: announcementIndexPath, is: .announcement(randomAnnouncement.element))
    }
    
}
