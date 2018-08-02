//
//  WhenBindingNonSponsorEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingNonSponsorEvent_SchedulePresenterShould: XCTestCase {
    
    func testNotShowTheSponsorOnlyIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertFalse(component.didShowSponsorEventIndicator)
    }
    
    func testHideTheSponsorOnlyIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertTrue(component.didHideSponsorEventIndicator)
    }
    
}
