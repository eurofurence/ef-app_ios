//
//  WhenBindingSponsorEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingSponsorEvent_SchedulePresenterShould: XCTestCase {
    
    func testShowTheSponsorOnlyIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isSponsorOnly = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertTrue(component.didShowSponsorEventIndicator)
    }
    
    func testNotHideTheSponsorOnlyIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isSponsorOnly = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertFalse(component.didHideSponsorEventIndicator)
    }
    
}
