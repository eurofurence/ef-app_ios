//
//  WhenPreparingViewModel_ForEventThatIsFavourite_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventThatIsFavourite_EventDetailInteractorShould: XCTestCase {

    func testTellTheDelegateItIsAFavourite() {
        let event = Event.random
        let service = FakeEventsService(favourites: [event.identifier])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)

        XCTAssertTrue(delegate.toldEventFavourited)
    }

    func testNotTellTheDelegateItIsUnfavourited() {
        let event = Event.random
        let service = FakeEventsService(favourites: [event.identifier])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)

        XCTAssertFalse(delegate.toldEventUnfavourited)
    }

}
