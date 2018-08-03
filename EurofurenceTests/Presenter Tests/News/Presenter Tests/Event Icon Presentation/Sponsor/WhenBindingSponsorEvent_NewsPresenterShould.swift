//
//  WhenBindingSponsorEvent_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingSponsorEvent_NewsPresenterShould: XCTestCase {
    
    func testShowTheSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSponsorEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertTrue(component.didShowSponsorEventIndicator)
    }
    
    func testNotHideTheSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSponsorEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertFalse(component.didHideSponsorEventIndicator)
    }
    
}
