//
//  WhenToldToFilterToFavouriteEvents_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenToldToFilterToFavouriteEvents_ScheduleInteractorShould: XCTestCase {

    func testTellTheSearchControllerToRestrictEventsToFavourites() {
        let eventsService = FakeEventsService()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        searchViewModel?.filterToFavourites()

        XCTAssertEqual(true, eventsService.lastProducedSearchController?.didRestrictSearchResultsToFavourites)
    }

}
