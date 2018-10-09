//
//  SchedulePresenterDealersDenIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class SchedulePresenterDealersDenIconBindingTests: XCTestCase {
    
    func testShowTheDealersDenIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isDealersDenEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertTrue(component.didShowDealersDenEventIndicator)
        XCTAssertFalse(component.didHideDealersDenEventIndicator)
    }
    
    func testHideTheDealersDenIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isDealersDenEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertFalse(component.didShowDealersDenEventIndicator)
        XCTAssertTrue(component.didHideDealersDenEventIndicator)
    }
    
}
