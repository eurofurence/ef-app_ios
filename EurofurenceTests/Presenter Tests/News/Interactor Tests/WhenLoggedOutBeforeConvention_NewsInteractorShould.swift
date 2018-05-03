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
    
    override func setUp() {
        super.setUp()
        
        let announcements = [Announcement2].random
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        context = DefaultNewsInteractorTestBuilder()
            .with(announcementsService)
            .with(FakeAuthenticationService(authState: .loggedOut))
            .build()
        context.subscribeViewModelUpdates()
    }
    
    func testProduceViewModelWithLoginPrompt_AndAnnouncements() {
        let expectedUserViewModel = context.makeExpectedUserWidget()
        let expectedAnnouncementViewModels = context.makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements()
        let expected = [expectedUserViewModel] + expectedAnnouncementViewModels
        let expectation = VerifyingNewsInteractorDelegate.Expectation(components: expected, titles: [.yourEurofurence, .announcements])
        
        context.verify(expectation)
    }
    
    func testFetchMessagesModuleValueWhenAskingForModelInFirstSection() {
        context.verifyModel(at: IndexPath(item: 0, section: 0), is: .messages)
    }
    
    func testFetchAnnouncementModuleValueWhenAskingForModelInSecondSection() {
        let randomAnnouncement = context.announcements.randomElement()
        let announcementIndexPath = IndexPath(item: randomAnnouncement.index, section: 1)
        
        context.verifyModel(at: announcementIndexPath, is: .announcement(randomAnnouncement.element))
    }
    
}
