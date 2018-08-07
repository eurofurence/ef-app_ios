//
//  WhenBindingNonArtShowEvent_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingNonArtShowEvent_NewsPresenterShould: XCTestCase {
    
    func testNotShowTheArtShowIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isArtShowEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertFalse(component.didShowArtShowEventIndicator)
    }
    
    func testHideTheArtShowIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isArtShowEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertTrue(component.didHideArtShowEventIndicator)
    }
    
}
