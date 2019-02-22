//
//  SchedulePresenterMainStageIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterMainStageIconBindingTests: XCTestCase {

    func testShowTheMainStageIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isMainStageEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertTrue(component.didShowMainStageEventIndicator)
        XCTAssertFalse(component.didHideMainStageEventIndicator)
    }

    func testHideTheMainStageIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isMainStageEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertFalse(component.didShowMainStageEventIndicator)
        XCTAssertTrue(component.didHideMainStageEventIndicator)
    }

}
