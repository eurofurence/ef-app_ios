//
//  WhenBindingNonArtShowEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingNonArtShowEvent_SchedulePresenterShould: XCTestCase {
    
    func testNotShowTheArtShowIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isArtShow = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertFalse(component.didShowArtShowEventIndicator)
    }
    
    func testHideTheArtShowIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isArtShow = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertTrue(component.didHideArtShowEventIndicator)
    }
    
}
