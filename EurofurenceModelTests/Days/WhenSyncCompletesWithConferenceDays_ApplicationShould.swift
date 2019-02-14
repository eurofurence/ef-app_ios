//
//  WhenSyncCompletesWithConferenceDays_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSyncCompletesWithConferenceDays_ApplicationShould: XCTestCase {

    func testProvideTheAdaptedDaysToObserversInDateOrder() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.eventsService.makeEventsSchedule()
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: syncResponse)

        DayAssertion()
            .assertDays(delegate.allDays, characterisedBy: syncResponse.conferenceDays.changed)
    }

    func testNotUpdateTheDelegateIfTheDaysHaveNotChangedBetweenSyncs() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.eventsService.makeEventsSchedule()
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: syncResponse)
        delegate.allDays.removeAll()
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertTrue(delegate.allDays.isEmpty)
    }

    func testNotUpdateTheDelegateIfTheDaysHaveNotChangedBetweenDataStoreAndSync() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.eventsService.makeEventsSchedule()
        schedule.setDelegate(delegate)
        delegate.allDays.removeAll()
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertTrue(delegate.allDays.isEmpty)
    }

    func testProvideLateAddedObserversWithAdaptedDays() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.eventsService.makeEventsSchedule()
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDays(delegate.allDays, characterisedBy: syncResponse.conferenceDays.changed)
    }

    func testSaveTheConferenceDaysToTheDataStore() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertTrue(context.dataStore.didSave(syncResponse.conferenceDays.changed))
    }

}
