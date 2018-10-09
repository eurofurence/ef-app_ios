//
//  NewsPresenterPhotoshootIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class NewsPresenterPhotoshootIconBindingTests: XCTestCase {
    
    func testShowThePhotoshootIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isPhotoshootEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertTrue(component.didShowPhotoshootStageEventIndicator)
        XCTAssertFalse(component.didHidePhotoshootStageEventIndicator)
    }
    
    func testHideThePhotoshootIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isPhotoshootEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertFalse(component.didShowPhotoshootStageEventIndicator)
        XCTAssertTrue(component.didHidePhotoshootStageEventIndicator)
    }
    
}
