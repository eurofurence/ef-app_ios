//
//  SchedulePresenterSponsorIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterSponsorIconBindingTests: XCTestCase {

    func testShowTheSponsorOnlyIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isSponsorOnly = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertTrue(component.didShowSponsorEventIndicator)
        XCTAssertFalse(component.didHideSponsorEventIndicator)
    }

    func testHideTheSponsorOnlyIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertFalse(component.didShowSponsorEventIndicator)
        XCTAssertTrue(component.didHideSponsorEventIndicator)
    }

}
