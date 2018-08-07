//
//  WhenBindingArtShowEvent_ForSearchResult_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingArtShowEvent_ForSearchResult_SchedulePresenterShould: XCTestCase {
    
    func testShowTheArtShowIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isArtShow = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)
        
        XCTAssertTrue(component.didShowArtShowEventIndicator)
    }
    
    func testNotHideTheArtShowIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isArtShow = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)
        
        XCTAssertFalse(component.didHideArtShowEventIndicator)
    }
    
}
