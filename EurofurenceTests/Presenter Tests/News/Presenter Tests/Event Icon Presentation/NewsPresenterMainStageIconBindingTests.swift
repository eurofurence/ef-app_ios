//
//  NewsPresenterMainStageIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class NewsPresenterMainStageIconBindingTests: XCTestCase {
    
    func testShowTheMainStageIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isMainStageEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertTrue(component.didShowMainStageEventIndicator)
        XCTAssertFalse(component.didHideMainStageEventIndicator)
    }
    
    func testHideTheMainStageIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isMainStageEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertFalse(component.didShowMainStageEventIndicator)
        XCTAssertTrue(component.didHideMainStageEventIndicator)
    }
    
}
