//
//  WhenAppLaunchesWhenClockDoesNotReadConferenceDay_ScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenAppLaunchesWhenClockDoesNotReadConferenceDay_ScheduleShould: XCTestCase {

    func testChangeToNilConDay() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(.distantPast).with(dataStore).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)

        XCTAssertTrue(delegate.toldChangedToNilDay)
    }

    func testRestrictEventsToTheFirstConferenceDay() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let firstDay = response.conferenceDays.changed.sorted(by: { $0.date < $1.date }).first!
        let dataStore = FakeDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).with(.distantPast).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == firstDay.identifier })

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

}
