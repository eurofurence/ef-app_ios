//
//  WhenToldToFilterToAllEvents_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenToldToFilterToAllEvents_ScheduleInteractorShould: XCTestCase {
    
    func testTellTheSearchControllerToLifeTheFavouritesRestriction() {
        let eventsService = FakeEventsService()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        searchViewModel?.filterToAllEvents()
        
        XCTAssertEqual(true, eventsService.lastProducedSearchController?.didLiftFavouritesSearchRestriction)
    }
    
}
