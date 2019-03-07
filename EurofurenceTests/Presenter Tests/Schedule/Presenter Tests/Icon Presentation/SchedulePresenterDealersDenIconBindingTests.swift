//
//  SchedulePresenterDealersDenIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterDealersDenIconBindingTests: XCTestCase {

    func testShowTheDealersDenIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isDealersDenEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.dealersDenIconVisibility, .visible)
    }

    func testHideTheDealersDenIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isDealersDenEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.dealersDenIconVisibility, .hidden)
    }

}
