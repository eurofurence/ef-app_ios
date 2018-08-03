//
//  WhenBindingNonSuperSponsorOnlyEvent_FromSearchResult_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingNonSuperSponsorOnlyEvent_FromSearchResult_SchedulePresenterShould: XCTestCase {
    
    func testNotShowTheSponsorOnlyIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isSuperSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)
        
        XCTAssertFalse(component.didShowSuperSponsorOnlyEventIndicator)
    }
    
    func testHideTheSponsorOnlyIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isSuperSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)
        
        XCTAssertTrue(component.didHideSuperSponsorOnlyEventIndicator)
    }
    
}
