//
//  WhenBindingNonSponsorEvent_ForSearchResult_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingNonSponsorEvent_ForSearchResult_SchedulePresenterShould: XCTestCase {
    
    func testNotShowTheSponsorOnlyIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)
        
        XCTAssertFalse(component.didShowSponsorEventIndicator)
    }
    
    func testHideTheSponsorOnlyIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)
        
        XCTAssertTrue(component.didHideSponsorEventIndicator)
    }
    
}
