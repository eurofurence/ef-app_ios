//
//  WhenBindingArtShowEvent_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingArtShowEvent_NewsPresenterShould: XCTestCase {
    
    func testShowTheArtShowIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isArtShowEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertTrue(component.didShowArtShowEventIndicator)
    }
    
    func testNotHideTheArtShowIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isArtShowEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertFalse(component.didHideArtShowEventIndicator)
    }
    
}
