//
//  WhenLoggedOutDuringConvention_WithNoUpcomingEvents_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedOutDuringConvention_WithNoUpcomingEvents_NewsInteractorShould: XCTestCase {

    func testProduceViewModelWithMessagesPrompt_Announcements_RunningEvents_AndFavouriteEvents() {
        let eventsService = FakeEventsService()
        let upcomingEvents = [Event]()
        eventsService.runningEvents = [StubEvent].random(minimum: 3)
        eventsService.upcomingEvents = upcomingEvents
        eventsService.stubSomeFavouriteEvents()
        let context = DefaultNewsInteractorTestBuilder()
            .with(FakeAuthenticationService.loggedOutService())
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .with(StubConventionCountdownService(countdownState: .countdownElapsed))
            .with(eventsService)
            .build()
        context.subscribeViewModelUpdates()

        context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasAnnouncements()
            .hasRunningEvents()
            .hasFavouriteEvents()
            .verify()
    }

}
