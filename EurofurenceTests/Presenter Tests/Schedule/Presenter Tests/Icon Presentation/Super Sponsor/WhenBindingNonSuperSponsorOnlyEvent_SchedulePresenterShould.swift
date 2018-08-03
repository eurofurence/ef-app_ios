//
//  WhenBindingNonSuperSponsorOnlyEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingNonSuperSponsorOnlyEvent_SchedulePresenterShould: XCTestCase {
    
    func testNotShowTheSponsorOnlyIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isSuperSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertFalse(component.didShowSuperSponsorOnlyEventIndicator)
    }
    
    func testHideTheSponsorOnlyIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isSuperSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertTrue(component.didHideSuperSponsorOnlyEventIndicator)
    }
    
}
