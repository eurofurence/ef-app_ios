//
//  WhenToldToUnfavouriteEvent_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToUnfavouriteEvent_ScheduleInteractorShould: XCTestCase {

    func testUnfavouriteTheEvent() {
        let eventsService = FakeEventsService()
        let events = [FakeEvent].random
        eventsService.allEvents = events
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let viewModel = context.makeViewModel()
        let randomGroup = context.eventsViewModels.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        let originalEvent = events.first(where: { $0.title == randomEvent.element.title })
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        viewModel?.unfavouriteEvent(at: indexPath)

        XCTAssertEqual(originalEvent?.favouritedState, .unfavourited)
    }

}
