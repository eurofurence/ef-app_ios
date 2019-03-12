//
//  WhenAppLaunchesWhenClockReadsConferenceDay_ScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenAppLaunchesWhenClockReadsConferenceDay_ScheduleShould: XCTestCase {

    func testChangeToExpectedConDay() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomDay = syncResponse.conferenceDays.changed.randomElement().element
        let dataStore = FakeDataStore()
        dataStore.save(syncResponse)
        let context = EurofurenceSessionTestBuilder().with(randomDay.date).with(dataStore).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDay(delegate.capturedCurrentDay, characterisedBy: randomDay)
    }

    func testPermitFuzzyMatchingAgainstHoursMinutesAndSecondsWithinDay() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomDay = syncResponse.conferenceDays.changed.randomElement().element
        var randomDayComponents = Calendar.current.dateComponents(in: .current, from: randomDay.date)
        randomDayComponents.hour = .random(upperLimit: 22)
        randomDayComponents.minute = .random(upperLimit: 58)
        randomDayComponents.second = .random(upperLimit: 58)
        let sameDayAsRandomDayButDifferentTime = randomDayComponents.date!
        let dataStore = FakeDataStore()
        dataStore.save(syncResponse)
        let context = EurofurenceSessionTestBuilder().with(sameDayAsRandomDayButDifferentTime).with(dataStore).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDay(delegate.capturedCurrentDay, characterisedBy: randomDay)
    }

    func testProvideEventsForThatDay() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let randomDay = response.conferenceDays.changed.randomElement().element
        let dataStore = FakeDataStore()
        dataStore.save(response)
        let imageRepository = CapturingImageRepository()
        imageRepository.stubEverything(response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).with(randomDay.date).with(imageRepository).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.identifier })

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

}
