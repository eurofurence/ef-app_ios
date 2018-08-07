//
//  WhenBindingNonArtShowEvent_ForSearchResult_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingNonArtShowEvent_ForSearchResult_SchedulePresenterShould: XCTestCase {
    
    func testNotShowTheArtShowIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isArtShow = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)
        
        XCTAssertFalse(component.didShowArtShowEventIndicator)
    }
    
    func testHideTheArtShowIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isArtShow = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)
        
        XCTAssertTrue(component.didHideArtShowEventIndicator)
    }
    
}
