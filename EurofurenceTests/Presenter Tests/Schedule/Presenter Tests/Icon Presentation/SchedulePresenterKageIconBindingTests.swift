//
//  SchedulePresenterKageIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterKageIconBindingTests: XCTestCase {

    func testShowTheKageIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isKageEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertTrue(component.didShowKageEventIndicator)
        XCTAssertFalse(component.didHideKageEventIndicator)
    }

    func testHideTheKageIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isKageEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertFalse(component.didShowKageEventIndicator)
        XCTAssertTrue(component.didHideKageEventIndicator)
    }

}
