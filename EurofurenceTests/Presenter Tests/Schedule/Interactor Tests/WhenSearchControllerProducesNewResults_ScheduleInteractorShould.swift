//
//  WhenSearchControllerProducesNewResults_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSearchControllerProducesNewResults_ScheduleInteractorShould: XCTestCase {

    func testGroupTheResultsByStartTimeWithDayAndTimeGroupTitle() {
        let firstGroupDate = Date.random
        let a = StubEvent.random
        a.startDate = firstGroupDate
        let b = StubEvent.random
        b.startDate = firstGroupDate
        let c = StubEvent.random
        c.startDate = firstGroupDate
        let firstGroupEvents = [a, b, c].sorted(by: { $0.title < $1.title })

        let secondGroupDate = firstGroupDate.addingTimeInterval(100)
        let d = StubEvent.random
        d.startDate = secondGroupDate
        let e = StubEvent.random
        e.startDate = secondGroupDate
        let secondGroupEvents = [d, e].sorted(by: { $0.title < $1.title })

        let results = firstGroupEvents + secondGroupEvents
        let eventsService = FakeEventsService()
        eventsService.favourites = [firstGroupEvents.randomElement().element.identifier]

        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        context.makeSearchViewModel()

        eventsService.lastProducedSearchController?.simulateSearchResultsChanged(results)

        let expectedEventViewModels = [ScheduleEventGroupViewModel(title: context.shortFormDayAndTimeFormatter.dayAndHoursString(from: firstGroupDate),
                                                                   events: firstGroupEvents.map(context.makeExpectedEventViewModel)),
                                       ScheduleEventGroupViewModel(title: context.shortFormDayAndTimeFormatter.dayAndHoursString(from: secondGroupDate),
                                                                   events: secondGroupEvents.map(context.makeExpectedEventViewModel))
        ]

        ScheduleEventGroupViewModelAssertion()
            .assertEventGroupViewModels(expectedEventViewModels, isEqualTo: context.searchViewModelDelegate.capturedSearchResults)
    }

    func testProvideTheExpectedIdentifier() {
        let firstGroupDate = Date.random
        let a = StubEvent.random
        a.startDate = firstGroupDate
        let b = StubEvent.random
        b.startDate = firstGroupDate
        let c = StubEvent.random
        c.startDate = firstGroupDate
        let firstGroupEvents = [a, b, c].sorted(by: { $0.title < $1.title })

        let secondGroupDate = firstGroupDate.addingTimeInterval(100)
        let d = StubEvent.random
        d.startDate = secondGroupDate
        let e = StubEvent.random
        e.startDate = secondGroupDate
        let secondGroupEvents = [d, e].sorted(by: { $0.title < $1.title })

        let results = firstGroupEvents + secondGroupEvents
        let eventsService = FakeEventsService()

        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let viewModel = context.makeSearchViewModel()

        eventsService.lastProducedSearchController?.simulateSearchResultsChanged(results)
        let randomEventInGroupOne = firstGroupEvents.randomElement()
        let indexPath = IndexPath(item: randomEventInGroupOne.index, section: 0)
        let expected = randomEventInGroupOne.element.identifier
        let actual = viewModel?.identifierForEvent(at: indexPath)

        XCTAssertEqual(expected, actual)
    }

}
