//
//  WhenUnfavouritingEventViewModel_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenUnfavouritingEventViewModel_EventDetailInteractorShould: XCTestCase {

    func testTellTheEventServiceToFavouriteTheEventByIdentifier() {
        let event = StubEvent.random
        let context = EventDetailInteractorTestBuilder().build(for: event)
        context.viewModel?.unfavourite()

        XCTAssertEqual(event.identifier, context.eventsService.unfavouritedEventIdentifier)
    }

}
