//
//  WhenBindingKageEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingKageEvent_SchedulePresenterShould: XCTestCase {
    
    func testShowTheKageIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isKageEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertTrue(component.didShowKageEventIndicator)
    }
    
    func testNotHideTheKageIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isKageEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertFalse(component.didHideKageEventIndicator)
    }
    
}
