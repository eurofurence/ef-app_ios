//
//  WhenBindingSponsorEvent_ForSearchResult_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingSponsorEvent_ForSearchResult_SchedulePresenterShould: XCTestCase {
    
    func testShowTheSponsorOnlyIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isSponsorOnly = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)
        
        XCTAssertTrue(component.didShowSponsorEventIndicator)
    }
    
    func testNotHideTheSponsorOnlyIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isSponsorOnly = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)
        
        XCTAssertFalse(component.didHideSponsorEventIndicator)
    }
    
}
