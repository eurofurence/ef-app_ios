//
//  WhenGroupingEventsByStartTime_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenGroupingEventsByStartTime_ScheduleInteractorShould: XCTestCase {

    var firstGroupEvents: [Event]!
    var secondGroupEvents: [Event]!
    var events: [Event]!
    var eventsService: FakeEventsService!
    var context: ScheduleInteractorTestBuilder.Context!
    var expectedEventViewModels: [ScheduleEventGroupViewModel]!

    override func setUp() {
        super.setUp()

        let firstGroupDate = Date.random
        let a = StubEvent.random
        a.startDate = firstGroupDate
        let b = StubEvent.random
        b.startDate = firstGroupDate
        let c = StubEvent.random
        c.startDate = firstGroupDate
        firstGroupEvents = [a, b, c].sorted(by: { $0.title < $1.title })

        let secondGroupDate = firstGroupDate.addingTimeInterval(100)
        let d = StubEvent.random
        d.startDate = secondGroupDate
        let e = StubEvent.random
        e.startDate = secondGroupDate
        secondGroupEvents = [d, e].sorted(by: { $0.title < $1.title })

        events = firstGroupEvents + secondGroupEvents
        eventsService = FakeEventsService()

        context = ScheduleInteractorTestBuilder().with(eventsService).build()
        expectedEventViewModels = [ScheduleEventGroupViewModel(title: context.hoursFormatter.hoursString(from: firstGroupDate),
                                                               events: firstGroupEvents.map(context.makeExpectedEventViewModel)),
                                   ScheduleEventGroupViewModel(title: context.hoursFormatter.hoursString(from: secondGroupDate),
                                                               events: secondGroupEvents.map(context.makeExpectedEventViewModel))
        ]
    }

    private func simulateEventsChanged() {
        eventsService.simulateEventsChanged(events)
    }

    func testGroupEventsByStartTime() {
        simulateEventsChanged()
        context.makeViewModel()

        XCTAssertEqual(expectedEventViewModels, context.eventsViewModels)
    }

    func testProvideUpdatedGroupsToDelegate() {
        context.makeViewModel()
        simulateEventsChanged()

        XCTAssertEqual(expectedEventViewModels, context.eventsViewModels)
    }

    func testProvideTheExpectedIdentifier() {
        simulateEventsChanged()
        let viewModel = context.makeViewModel()

        let randomEventInGroupOne = firstGroupEvents.randomElement()
        let indexPath = IndexPath(item: randomEventInGroupOne.index, section: 0)
        let expected = randomEventInGroupOne.element.identifier
        let actual = viewModel?.identifierForEvent(at: indexPath)

        XCTAssertEqual(expected, actual)
    }

}
