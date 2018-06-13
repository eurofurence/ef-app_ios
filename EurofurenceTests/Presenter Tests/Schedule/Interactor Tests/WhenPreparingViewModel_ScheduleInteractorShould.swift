//
//  WhenPreparingViewModel_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModel_ScheduleInteractorShould: XCTestCase {
    
    func testGroupEventsByStartTime() {
        let firstGroupDate = Date.random
        var a = Event2.random
        a.startDate = firstGroupDate
        var b = Event2.random
        b.startDate = firstGroupDate
        var c = Event2.random
        c.startDate = firstGroupDate
        let firstGroup = [a, b, c].sorted(by: { $0.title < $1.title })
        
        let secondGroupDate = firstGroupDate.addingTimeInterval(100)
        var d = Event2.random
        d.startDate = secondGroupDate
        var e = Event2.random
        e.startDate = secondGroupDate
        let secondGroup = [d, e].sorted(by: { $0.title < $1.title })
        
        let allEvents = firstGroup + secondGroup
        let eventsService = StubEventsService()
        eventsService.allEvents = allEvents
        
        let hoursFormatter = FakeHoursDateFormatter()
        let interactor = DefaultScheduleInteractor(eventsService: eventsService,
                                                   hoursDateFormatter: hoursFormatter)
        let delegate = CapturingScheduleInteractorDelegate()
        interactor.setDelegate(delegate)
        
        let eventViewModelFromEvent: (Event2) -> ScheduleEventViewModel = { (event) in
            return ScheduleEventViewModel(title: event.title,
                                          startTime: hoursFormatter.hoursString(from: event.startDate),
                                          endTime: hoursFormatter.hoursString(from: event.endDate),
                                          location: event.room.name)
        }
        
        let expected = ScheduleViewModel(eventGroups: [
            ScheduleEventGroupViewModel(title: hoursFormatter.hoursString(from: firstGroupDate),
                                        events: firstGroup.map(eventViewModelFromEvent)),
            ScheduleEventGroupViewModel(title: hoursFormatter.hoursString(from: secondGroupDate),
                                        events: secondGroup.map(eventViewModelFromEvent))
            ])
        
        XCTAssertEqual(expected, delegate.viewModel)
    }
    
    func testProvideUpdatedGroupsToDelegate() {
        let firstGroupDate = Date.random
        var a = Event2.random
        a.startDate = firstGroupDate
        var b = Event2.random
        b.startDate = firstGroupDate
        var c = Event2.random
        c.startDate = firstGroupDate
        let firstGroup = [a, b, c].sorted(by: { $0.title < $1.title })
        
        let secondGroupDate = firstGroupDate.addingTimeInterval(100)
        var d = Event2.random
        d.startDate = secondGroupDate
        var e = Event2.random
        e.startDate = secondGroupDate
        let secondGroup = [d, e].sorted(by: { $0.title < $1.title })
        
        let eventsService = CapturingEventsService()
        let hoursFormatter = FakeHoursDateFormatter()
        let interactor = DefaultScheduleInteractor(eventsService: eventsService,
                                                   hoursDateFormatter: hoursFormatter)
        let delegate = CapturingScheduleInteractorDelegate()
        interactor.setDelegate(delegate)
        
        let allEvents = firstGroup + secondGroup
        eventsService.simulateEventsChanged(allEvents)
        
        let eventViewModelFromEvent: (Event2) -> ScheduleEventViewModel = { (event) in
            return ScheduleEventViewModel(title: event.title,
                                          startTime: hoursFormatter.hoursString(from: event.startDate),
                                          endTime: hoursFormatter.hoursString(from: event.endDate),
                                          location: event.room.name)
        }
        
        let expected = ScheduleViewModel(eventGroups: [
            ScheduleEventGroupViewModel(title: hoursFormatter.hoursString(from: firstGroupDate),
                                        events: firstGroup.map(eventViewModelFromEvent)),
            ScheduleEventGroupViewModel(title: hoursFormatter.hoursString(from: secondGroupDate),
                                        events: secondGroup.map(eventViewModelFromEvent))
            ])
        
        XCTAssertEqual(expected, delegate.viewModel)
    }
    
}
