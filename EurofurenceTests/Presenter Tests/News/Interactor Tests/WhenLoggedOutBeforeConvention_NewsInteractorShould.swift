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
    
    func testProduceViewModelWithLoginPrompt_AndAnnouncements() {
        let loggedOutAuthService = FakeAuthenticationService(authState: .loggedOut)
        let announcements = [Announcement2].random
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let delegate = VerifyingNewsInteractorDelegate()
        let interactor = DefaultNewsInteractor(announcementsService: announcementsService, authenticationService: loggedOutAuthService)
        interactor.subscribeViewModelUpdates(delegate)
        let expectedUserViewModel = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                                 detailedPrompt: .anonymousUserLoginDescription,
                                                                 hasUnreadMessages: false)
        let expectedAnnouncementViewModels = announcements.map(makeExpectedAnnouncementViewModel).map(AnyHashable.init)
        let expected = [AnyHashable(expectedUserViewModel)] + expectedAnnouncementViewModels
        let expectation = VerifyingNewsInteractorDelegate.Expectation(components: expected, titles: [.yourEurofurence, .announcements])
        
        delegate.verify(expectation)
    }
    
    func testFetchMessagesModuleValueWhenAskingForModelInFirstSection() {
        let loggedOutAuthService = FakeAuthenticationService(authState: .loggedOut)
        let announcements = [Announcement2].random
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let delegate = VerifyingNewsInteractorDelegate()
        let interactor = DefaultNewsInteractor(announcementsService: announcementsService, authenticationService: loggedOutAuthService)
        interactor.subscribeViewModelUpdates(delegate)
        
        delegate.verifyModel(at: IndexPath(item: 0, section: 0), is: .messages)
    }
    
    private func makeExpectedAnnouncementViewModel(from announcement: Announcement2) -> AnnouncementComponentViewModel {
        return AnnouncementComponentViewModel(title: announcement.title, detail: announcement.content)
    }
    
}
