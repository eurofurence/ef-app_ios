//
//  WhenFetchingDaysBeforeRefreshWhenStoreHasConferenceDays.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFetchingDaysBeforeRefreshWhenStoreHasConferenceDays: XCTestCase {

    func testTheEventsFromTheStoreAreAdapted() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: response)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.eventsService.makeEventsSchedule()
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDays(delegate.allDays, characterisedBy: response.conferenceDays.changed)
    }

}
