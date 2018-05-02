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
        return Context(interactor: interactor,
                       authenticationService: authenticationService,
                       announcementsService: announcementsService)
    }
    
}

extension DefaultNewsInteractorTestBuilder.Context {
    
    var announcements: [Announcement2] {
        return announcementsService.announcements
    }
    
    func makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements() -> [AnyHashable] {
        return announcements.map(makeExpectedAnnouncementViewModel).map(AnyHashable.init)
    }
    
    func makeExpectedAnnouncementViewModel(from announcement: Announcement2) -> AnnouncementComponentViewModel {
        return AnnouncementComponentViewModel(title: announcement.title, detail: announcement.content)
    }
    
}
