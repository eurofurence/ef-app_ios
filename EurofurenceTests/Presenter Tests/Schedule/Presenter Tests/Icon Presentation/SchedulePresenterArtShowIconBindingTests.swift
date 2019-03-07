//
//  SchedulePresenterArtShowIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterArtShowIconBindingTests: XCTestCase {

    func testShowTheArtShowIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isArtShow = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.artShowIconVisibility, .visible)
    }

    func testHideTheArtShowIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isArtShow = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.artShowIconVisibility, .hidden)
    }

}
