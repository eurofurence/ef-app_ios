//
//  WhenViewModelIsToldToShowEventsForSpecificDay_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCore
import XCTest

class WhenViewModelIsToldToShowEventsForSpecificDay_ScheduleInteractorShould: XCTestCase {
    
    func testTellTheScheduleToRestrictEventsToSpecifiedDay() {
        let days: [Day] = .random
        let eventsService = FakeEventsService()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        eventsService.simulateDaysChanged(days)
        let viewModel = context.makeViewModel()
        let randomDay = days.randomElement()
        viewModel?.showEventsForDay(at: randomDay.index)
        
        XCTAssertEqual(randomDay.element, eventsService.lastProducedSchedule?.dayUsedToRestrictEvents)
    }
    
}
