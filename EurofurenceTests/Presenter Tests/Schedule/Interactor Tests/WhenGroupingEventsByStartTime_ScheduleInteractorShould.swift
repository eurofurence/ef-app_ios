//
//  WhenGroupingEventsByStartTime_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenGroupingEventsByStartTime_ScheduleInteractorShould: XCTestCase {
    
    struct DateGroupedEvents {
        var date: Date
        var events: [Event2]
    }
    
    var firstGroup: DateGroupedEvents!
    var secondGroup: DateGroupedEvents!
    var eventsService: CapturingEventsService!
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
        let firstGroupEvents = [a, b, c].sorted(by: { $0.title < $1.title })
        firstGroup = DateGroupedEvents(date: firstGroupDate, events: firstGroupEvents)
        
        let secondGroupDate = firstGroupDate.addingTimeInterval(100)
        var d = Event2.random
        d.startDate = secondGroupDate
        var e = Event2.random
        e.startDate = secondGroupDate
        let secondGroupEvents = [d, e].sorted(by: { $0.title < $1.title })
        secondGroup = DateGroupedEvents(date: secondGroupDate, events: secondGroupEvents)
        
        eventsService = CapturingEventsService()
        
        context = ScheduleInteractorTestBuilder().with(eventsService).build()
        expectedEventViewModels = [ScheduleEventGroupViewModel(title: context.hoursFormatter.hoursString(from: firstGroup.date),
                                                               events: firstGroup.events.map(context.makeExpectedEventViewModel)),
                                   ScheduleEventGroupViewModel(title: context.hoursFormatter.hoursString(from: secondGroup.date),
                                                               events: secondGroup.events.map(context.makeExpectedEventViewModel))
        ]
    }
    
    func testGroupEventsByStartTime() {
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        eventsService.simulateEventsChanged(firstGroup.events + secondGroup.events)
        
        XCTAssertEqual(expectedEventViewModels, delegate.eventsViewModels)
    }
    
    func testProvideUpdatedGroupsToDelegate() {
        eventsService.simulateEventsChanged(firstGroup.events + secondGroup.events)
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        
        XCTAssertEqual(expectedEventViewModels, delegate.eventsViewModels)
    }
    
}
