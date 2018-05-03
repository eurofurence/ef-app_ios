//
//  DefaultNewsInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class DefaultNewsInteractorTestBuilder {
    
    struct Context {
        var interactor: DefaultNewsInteractor
        var delegate: VerifyingNewsInteractorDelegate
        var authenticationService: FakeAuthenticationService
        var announcementsService: StubAnnouncementsService
    }
    
    private var announcementsService: StubAnnouncementsService
    private var authenticationService: FakeAuthenticationService
    
    init() {
        announcementsService = StubAnnouncementsService(announcements: [])
        authenticationService = FakeAuthenticationService(authState: .loggedOut)
    }
    
    @discardableResult
    func with(_ announcementsService: StubAnnouncementsService) -> DefaultNewsInteractorTestBuilder {
        self.announcementsService = announcementsService
        return self
    }
    
    @discardableResult
    func with(_ authService: FakeAuthenticationService) -> DefaultNewsInteractorTestBuilder {
        self.authenticationService = authService
        return self
    }
    
    func build() -> Context {
        let interactor = DefaultNewsInteractor(announcementsService: announcementsService,
                                               authenticationService: authenticationService)
        let delegate = VerifyingNewsInteractorDelegate()
        
        return Context(interactor: interactor,
                       delegate: delegate,
                       authenticationService: authenticationService,
                       announcementsService: announcementsService)
    }
    
}

// MARK: Convenience Functions

extension DefaultNewsInteractorTestBuilder.Context {
    
    var announcements: [Announcement2] {
        return announcementsService.announcements
    }
    
    func makeExpectedUserWidget() -> AnyHashable {
        switch authenticationService.authState {
        case .loggedIn(let user):
            return UserWidgetComponentViewModel(prompt: String.welcomePrompt(for: user),
                                                detailedPrompt: String.welcomeDescription(messageCount: 0),
                                                hasUnreadMessages: false) // TODO: Take unread messages into account
            
        case .loggedOut:
            return UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                detailedPrompt: .anonymousUserLoginDescription,
                                                hasUnreadMessages: false)
        }
    }
    
    func makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements() -> [AnyHashable] {
        return announcements.map(makeExpectedAnnouncementViewModel).map(AnyHashable.init)
    }
    
    func makeExpectedAnnouncementViewModel(from announcement: Announcement2) -> AnnouncementComponentViewModel {
        return AnnouncementComponentViewModel(title: announcement.title, detail: announcement.content)
    }
    
}

// MARK: Assertion Assistance

extension DefaultNewsInteractorTestBuilder.Context {
    
    func subscribeViewModelUpdates() {
        interactor.subscribeViewModelUpdates(delegate)
    }
    
    func verify(_ expectation: VerifyingNewsInteractorDelegate.Expectation, file: StaticString = #file, line: UInt = #line) {
        delegate.verify(expectation, file: file, line: line)
    }
    
    func verifyModel(at indexPath: IndexPath, is expected: NewsViewModelValue, file: StaticString = #file, line: UInt = #line) {
        delegate.verifyModel(at: indexPath, is: expected, file: file, line: line)
    }
    
}
