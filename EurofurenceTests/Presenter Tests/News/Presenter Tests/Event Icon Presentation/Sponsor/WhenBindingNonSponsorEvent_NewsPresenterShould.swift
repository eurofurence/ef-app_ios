//
//  WhenBindingNonSponsorEvent_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingNonSponsorEvent_NewsPresenterShould: XCTestCase {
    
    func testNotShowTheSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSponsorEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertFalse(component.didShowSponsorEventIndicator)
    }
    
    func testHideTheSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSponsorEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertTrue(component.didHideSponsorEventIndicator)
    }
    
}
