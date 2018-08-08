//
//  WhenBindingNonKageEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingNonKageEvent_SchedulePresenterShould: XCTestCase {
    
    func testNotShowTheKageIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isKageEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertFalse(component.didShowKageEventIndicator)
    }
    
    func testHideTheKageIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isKageEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertTrue(component.didHideKageEventIndicator)
    }
    
}
