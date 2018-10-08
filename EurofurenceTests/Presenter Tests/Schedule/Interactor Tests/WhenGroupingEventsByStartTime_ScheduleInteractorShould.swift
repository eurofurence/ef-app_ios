//
//  WhenGroupingEventsByStartTime_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenGroupingEventsByStartTime_ScheduleInteractorShould: XCTestCase {
    
    var firstGroupEvents: [Event2]!
    var secondGroupEvents: [Event2]!
    var events: [Event2]!
    var eventsService: FakeEventsService!
    var context: ScheduleInteractorTestBuilder.Context!
    var expectedEventViewModels: [ScheduleEventGroupViewModel]!
    
    override func setUp() {
        super.setUp()
        
        let firstGroupDate = Date.random
        var a = Event2.random
        a.startDate = firstGroupDate
        var b = Event2.random
        b.startDate = firstGroupDate
        var c = Event2.random
        c.startDate = firstGroupDate
        firstGroupEvents = [a, b, c].sorted(by: { $0.title < $1.title })
        
        let secondGroupDate = firstGroupDate.addingTimeInterval(100)
        var d = Event2.random
        d.startDate = secondGroupDate
        var e = Event2.random
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
