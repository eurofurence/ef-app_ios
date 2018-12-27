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
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isArtShow = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertTrue(component.didShowArtShowEventIndicator)
        XCTAssertFalse(component.didHideArtShowEventIndicator)
    }

    func testHideTheArtShowIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isArtShow = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertFalse(component.didShowArtShowEventIndicator)
        XCTAssertTrue(component.didHideArtShowEventIndicator)
    }

}
