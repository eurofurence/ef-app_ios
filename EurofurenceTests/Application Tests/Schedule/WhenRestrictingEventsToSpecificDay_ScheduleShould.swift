//
//  WhenRestrictingEventsToSpecificDay_ScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class WhenRestrictingEventsToSpecificDay_ScheduleShould: XCTestCase {
    
    func testOnlyIncludeEventsRunningOnThatDay() {
        let response = APISyncResponse.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(response)
        let imageRepository = CapturingImageRepository()
        imageRepository.stubEverything(response)
        let context = ApplicationTestBuilder().with(dataStore).with(imageRepository).build()
        let schedule = context.application.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let randomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        let expected = context.makeExpectedEvents(from: expectedEvents, response: response)
        schedule.restrictEvents(to: Day(date: randomDay.element.date))
        
        XCTAssertEqual(expected, delegate.events)
    }
    
    func testUpdateRestrictedScheduleWhenLaterSyncCompletes() {
        let response = APISyncResponse.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(response)
        let imageRepository = CapturingImageRepository()
        imageRepository.stubEverything(response)
        let context = ApplicationTestBuilder().with(dataStore).with(imageRepository).build()
        let schedule = context.application.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        let randomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        let expected = context.makeExpectedEvents(from: expectedEvents, response: response)
        schedule.restrictEvents(to: Day(date: randomDay.element.date))
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        schedule.setDelegate(delegate)
        
        XCTAssertEqual(expected, delegate.events)
    }
    
    func testRestrictEventsOnlyToTheLastSpecifiedRestrictedDay() {
        let response = APISyncResponse.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(response)
        let imageRepository = CapturingImageRepository()
        imageRepository.stubEverything(response)
        let context = ApplicationTestBuilder().with(dataStore).with(imageRepository).build()
        let schedule = context.application.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let randomDay = response.conferenceDays.changed.randomElement()
        let anotherRandomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        let expected = context.makeExpectedEvents(from: expectedEvents, response: response)
        schedule.restrictEvents(to: Day(date: anotherRandomDay.element.date))
        schedule.restrictEvents(to: Day(date: randomDay.element.date))
        
        XCTAssertEqual(expected, delegate.events)
    }
    
}
