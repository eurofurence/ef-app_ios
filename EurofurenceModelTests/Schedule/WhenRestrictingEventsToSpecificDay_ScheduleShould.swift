//
//  WhenRestrictingEventsToSpecificDay_ScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenRestrictingEventsToSpecificDay_ScheduleShould: XCTestCase {

    func testOnlyIncludeEventsRunningOnThatDay() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(response)
        let imageRepository = CapturingImageRepository()
        imageRepository.stubEverything(response)
        let context = ApplicationTestBuilder().with(dataStore).with(imageRepository).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let randomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        schedule.restrictEvents(to: Day(date: randomDay.element.date))

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

    func testUpdateRestrictedScheduleWhenLaterSyncCompletes() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(response)
        let imageRepository = CapturingImageRepository()
        imageRepository.stubEverything(response)
        let context = ApplicationTestBuilder().with(dataStore).with(imageRepository).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        let randomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        schedule.restrictEvents(to: Day(date: randomDay.element.date))
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        schedule.setDelegate(delegate)

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

    func testRestrictEventsOnlyToTheLastSpecifiedRestrictedDay() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(response)
        let imageRepository = CapturingImageRepository()
        imageRepository.stubEverything(response)
        let context = ApplicationTestBuilder().with(dataStore).with(imageRepository).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let randomDay = response.conferenceDays.changed.randomElement()
        let anotherRandomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        schedule.restrictEvents(to: Day(date: anotherRandomDay.element.date))
        schedule.restrictEvents(to: Day(date: randomDay.element.date))

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

}
