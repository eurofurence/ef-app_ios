//
//  SchedulePresenterSuperSponsorIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterSuperSponsorIconBindingTests: XCTestCase {

    func testShowTheSponsorOnlyIndicator() {
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isSuperSponsorOnly = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(searchResult)

        XCTAssertTrue(component.didShowSuperSponsorOnlyEventIndicator)
        XCTAssertFalse(component.didHideSuperSponsorOnlyEventIndicator)
    }

    func testHideTheSponsorOnlyIndicator() {
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isSuperSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(searchResult)

        XCTAssertFalse(component.didShowSuperSponsorOnlyEventIndicator)
        XCTAssertTrue(component.didHideSuperSponsorOnlyEventIndicator)
    }

}
