//
//  WhenBindingNonSuperSponsorEvent_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingNonSuperSponsorEvent_NewsPresenterShould: XCTestCase {
    
    func testNotShowTheSuperSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSuperSponsorEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertFalse(component.didShowSuperSponsorOnlyEventIndicator)
    }
    
    func testHideTheSuperSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSuperSponsorEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertTrue(component.didHideSuperSponsorOnlyEventIndicator)
    }
    
}
