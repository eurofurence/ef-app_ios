//
//  WhenToldToUnfavouriteEvent_FromSearchViewModel_InteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToUnfavouriteEvent_FromSearchViewModel_InteractorShould: XCTestCase {

    func testTellTheEventsServiceToUnfavouriteTheEvent() {
        let eventsService = FakeEventsService()
        let events = [Event].random
        eventsService.allEvents = events
        let randomEvent = events.randomElement()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let viewModel = context.makeSearchViewModel()
        eventsService.lastProducedSearchController?.simulateSearchResultsChanged([randomEvent.element])
        viewModel?.updateSearchResults(input: randomEvent.element.title)
        let indexPath = IndexPath(item: 0, section: 0)
        viewModel?.unfavouriteEvent(at: indexPath)

        XCTAssertEqual(randomEvent.element.identifier, eventsService.unfavouritedEventIdentifier)
    }

}
