//
//  DefaultNewsInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct StubAnnouncementsService: AnnouncementsService {
    
    var announcements: [Announcement2]
    
    func fetchAnnouncements(completionHandler: @escaping ([Announcement2]) -> Void) {
        completionHandler(announcements)
    }
    
}

class DefaultNewsInteractorTests: XCTestCase {
    
    func testNotBeingLoggedInEmitsViewModelWithLoginPromptUserWidgetViewModel() {
        let loggedOutAuthService = FakeAuthenticationService(authState: .loggedOut)
        let announcements = [Announcement2].random
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let delegate = CapturingNewsInteractorDelegate()
        let interactor = DefaultNewsInteractor(announcementsService: announcementsService, authenticationService: loggedOutAuthService)
        interactor.subscribeViewModelUpdates(delegate)
        let expectedUserViewModel = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                                 detailedPrompt: .anonymousUserLoginDescription,
                                                                 hasUnreadMessages: false)
        let expectedAnnouncementViewModels = announcements.map(makeExpectedAnnouncementViewModel).map(AnyHashable.init)
        let expected = [AnyHashable(expectedUserViewModel)] + expectedAnnouncementViewModels
        
        XCTAssertTrue(delegate.didWitnessViewModelWithComponents(expected))
    }
    
    private func makeExpectedAnnouncementViewModel(from announcement: Announcement2) -> AnnouncementComponentViewModel {
        return AnnouncementComponentViewModel(title: announcement.title, detail: announcement.content)
    }
    
}
