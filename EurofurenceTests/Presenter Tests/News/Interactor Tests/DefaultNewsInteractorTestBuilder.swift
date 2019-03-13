//
//  DefaultNewsInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class DefaultNewsInteractorTestBuilder {

    struct Context {
        var interactor: DefaultNewsInteractor
        var delegate: CapturingNewsInteractorDelegate
        var relativeTimeFormatter: FakeRelativeTimeIntervalCountdownFormatter
        var hoursDateFormatter: FakeHoursDateFormatter
        var authenticationService: FakeAuthenticationService
        var announcementsService: FakeAnnouncementsService
        var privateMessagesService: CapturingPrivateMessagesService
        var daysUntilConventionService: StubConventionCountdownService
        var eventsService: FakeEventsService
        var dateDistanceCalculator: StubDateDistanceCalculator
        var clock: StubClock
        var refreshService: CapturingRefreshService
        var announcementDateFormatter: FakeAnnouncementDateFormatter
		var markdownRenderer: StubMarkdownRenderer
    }

    private var announcementsService: FakeAnnouncementsService
    private var authenticationService: FakeAuthenticationService
    private var privateMessagesService: CapturingPrivateMessagesService
    private var daysUntilConventionService: StubConventionCountdownService
    private var eventsService: FakeEventsService

    init() {
        announcementsService = FakeAnnouncementsService(announcements: [])
        authenticationService = FakeAuthenticationService(authState: .loggedOut)
        privateMessagesService = CapturingPrivateMessagesService()
        daysUntilConventionService = StubConventionCountdownService()
        eventsService = FakeEventsService()
    }

    @discardableResult
    func with(_ announcementsService: FakeAnnouncementsService) -> DefaultNewsInteractorTestBuilder {
        self.announcementsService = announcementsService
        return self
    }

    @discardableResult
    func with(_ authService: FakeAuthenticationService) -> DefaultNewsInteractorTestBuilder {
        self.authenticationService = authService
        return self
    }

    @discardableResult
    func with(_ privateMessagesService: CapturingPrivateMessagesService) -> DefaultNewsInteractorTestBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }

    @discardableResult
    func with(_ daysUntilConventionService: StubConventionCountdownService) -> DefaultNewsInteractorTestBuilder {
        self.daysUntilConventionService = daysUntilConventionService
        return self
    }

    @discardableResult
    func with(_ eventsService: FakeEventsService) -> DefaultNewsInteractorTestBuilder {
        self.eventsService = eventsService
        return self
    }

    func build() -> Context {
        let dateDistanceCalculator = StubDateDistanceCalculator()
        let clock = StubClock()
        let relativeTimeFormatter = FakeRelativeTimeIntervalCountdownFormatter()
        let hoursDateFormatter = FakeHoursDateFormatter()
        let refreshService = CapturingRefreshService()
        let announcementsDateFormatter = FakeAnnouncementDateFormatter()
		let markdownRenderer = StubMarkdownRenderer()
        let interactor = DefaultNewsInteractor(announcementsService: announcementsService,
                                               authenticationService: authenticationService,
                                               privateMessagesService: privateMessagesService,
                                               daysUntilConventionService: daysUntilConventionService,
                                               eventsService: eventsService,
                                               relativeTimeIntervalCountdownFormatter: relativeTimeFormatter,
                                               hoursDateFormatter: hoursDateFormatter,
                                               dateDistanceCalculator: dateDistanceCalculator,
                                               clock: clock,
                                               refreshService: refreshService,
                                               announcementsDateFormatter: announcementsDateFormatter,
											   announcementsMarkdownRenderer: markdownRenderer)
        let delegate = CapturingNewsInteractorDelegate()

        return Context(interactor: interactor,
                       delegate: delegate,
                       relativeTimeFormatter: relativeTimeFormatter,
                       hoursDateFormatter: hoursDateFormatter,
                       authenticationService: authenticationService,
                       announcementsService: announcementsService,
                       privateMessagesService: privateMessagesService,
                       daysUntilConventionService: daysUntilConventionService,
                       eventsService: eventsService,
                       dateDistanceCalculator: dateDistanceCalculator,
                       clock: clock,
                       refreshService: refreshService,
                       announcementDateFormatter: announcementsDateFormatter,
					   markdownRenderer: markdownRenderer)
    }

}
