//
//  WhenScheduleIndicatesCurrentDayHasChanged_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenScheduleIndicatesCurrentDayHasChanged_NewsInteractorShould: XCTestCase {

    func testRestrictTheEventsToTheCurrentDay() {
        let eventsService = FakeEventsService()
        let context = DefaultNewsInteractorTestBuilder().with(eventsService).build()
        context.subscribeViewModelUpdates()
        let day = Day.random
        eventsService.lastProducedSchedule?.simulateDayChanged(to: day)

        XCTAssertEqual(day, eventsService.lastProducedSchedule?.dayUsedToRestrictEvents)
    }

    func testNotIncludeFavouritesSectionWhenDayIsNil() {
        let eventsService = FakeEventsService()
        let context = DefaultNewsInteractorTestBuilder().with(eventsService).build()
        context.subscribeViewModelUpdates()
        eventsService.lastProducedSchedule?.simulateDayChanged(to: nil)

        context
            .assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
