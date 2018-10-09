//
//  NewsPresenterSponsorIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class NewsPresenterSponsorIconBindingTests: XCTestCase {
    
    func testShowTheSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSponsorEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertTrue(component.didShowSponsorEventIndicator)
        XCTAssertFalse(component.didHideSponsorEventIndicator)
    }
    
    func testHideTheSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSponsorEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertFalse(component.didShowSponsorEventIndicator)
        XCTAssertTrue(component.didHideSponsorEventIndicator)
    }
    
}
