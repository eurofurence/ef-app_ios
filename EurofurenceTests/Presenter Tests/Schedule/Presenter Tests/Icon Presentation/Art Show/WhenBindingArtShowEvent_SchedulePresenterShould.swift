//
//  WhenBindingArtShowEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingArtShowEvent_SchedulePresenterShould: XCTestCase {
    
    func testShowTheArtShowIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isArtShow = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertTrue(component.didShowArtShowEventIndicator)
    }
    
    func testNotHideTheArtShowIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isArtShow = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertFalse(component.didHideArtShowEventIndicator)
    }
    
}
