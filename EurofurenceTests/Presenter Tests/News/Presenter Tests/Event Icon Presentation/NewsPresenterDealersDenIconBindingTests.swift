//
//  NewsPresenterDealersDenIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class NewsPresenterDealersDenIconBindingTests: XCTestCase {
    
    func testShowTheDealersDenIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isDealersDenEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertTrue(component.didShowDealersDenEventIndicator)
        XCTAssertFalse(component.didHideDealersDenEventIndicator)
    }
    
    func testHideTheDealersDenIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isDealersDenEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)
        
        XCTAssertFalse(component.didShowDealersDenEventIndicator)
        XCTAssertTrue(component.didHideDealersDenEventIndicator)
    }
    
}
