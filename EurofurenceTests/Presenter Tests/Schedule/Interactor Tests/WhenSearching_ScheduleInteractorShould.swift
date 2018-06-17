//
//  WhenSearching_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSearching_ScheduleInteractorShould: XCTestCase {
    
    func testChangeSearchTermToUsedInput() {
        let eventsService = FakeEventsService()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        let term = String.random
        searchViewModel?.updateSearchResults(input: term)
        
        XCTAssertEqual(term, eventsService.lastProducedSearchController?.capturedSearchTerm)
    }
    
}
