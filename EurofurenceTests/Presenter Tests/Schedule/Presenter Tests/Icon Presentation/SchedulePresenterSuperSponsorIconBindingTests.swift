//
//  SchedulePresenterSuperSponsorIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class SchedulePresenterSuperSponsorIconBindingTests: XCTestCase {
    
    func testShowTheSponsorOnlyIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isSuperSponsorOnly = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(searchResult)
        
        XCTAssertTrue(component.didShowSuperSponsorOnlyEventIndicator)
        XCTAssertFalse(component.didHideSuperSponsorOnlyEventIndicator)
    }
    
    func testHideTheSponsorOnlyIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isSuperSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(searchResult)
        
        XCTAssertFalse(component.didShowSuperSponsorOnlyEventIndicator)
        XCTAssertTrue(component.didHideSuperSponsorOnlyEventIndicator)
    }
    
}
