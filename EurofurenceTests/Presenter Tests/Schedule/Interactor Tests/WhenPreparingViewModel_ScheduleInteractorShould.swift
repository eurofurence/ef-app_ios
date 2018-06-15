//
//  WhenPreparingViewModel_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class FakeShortFormDateFormatter: ShortFormDateFormatter {
    
    func dateString(from date: Date) -> String {
        return "Short Form | \(date.description)"
    }
    
}

class ScheduleInteractorTestBuilder {
    
    struct Context {
        var interactor: DefaultScheduleInteractor
        var hoursFormatter: FakeHoursDateFormatter
        var shortFormDateFormatter: FakeShortFormDateFormatter
    }
    
    private var eventsService: EventsService
    
    init() {
        eventsService = StubEventsService()
    }
    
    @discardableResult
    func with(_ eventsService: EventsService) -> ScheduleInteractorTestBuilder {
        self.eventsService = eventsService
        return self
    }
    
    func build() -> Context {
        let hoursFormatter = FakeHoursDateFormatter()
        let shortFormDateFormatter = FakeShortFormDateFormatter()
        let interactor = DefaultScheduleInteractor(eventsService: eventsService,
                                                   hoursDateFormatter: hoursFormatter,
                                                   shortFormDateFormatter: shortFormDateFormatter)
        
        return Context(interactor: interactor,
                       hoursFormatter: hoursFormatter,
                       shortFormDateFormatter: shortFormDateFormatter)
    }
    
}

extension ScheduleInteractorTestBuilder.Context {
    
    func makeExpectedEventViewModel(from event: Event2) -> ScheduleEventViewModel {
        return ScheduleEventViewModel(title: event.title,
                                      startTime: hoursFormatter.hoursString(from: event.startDate),
                                      endTime: hoursFormatter.hoursString(from: event.endDate),
                                      location: event.room.name)
    }
    
    func makeExpectedDayViewModel(from day: Day) -> ScheduleDayViewModel {
        return ScheduleDayViewModel(title: shortFormDateFormatter.dateString(from: day.date))
    }
    
}

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
        
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        
        let expected = [ScheduleEventGroupViewModel(title: context.hoursFormatter.hoursString(from: firstGroupDate),
                                                    events: firstGroup.map(context.makeExpectedEventViewModel)),
                        ScheduleEventGroupViewModel(title: context.hoursFormatter.hoursString(from: secondGroupDate),
                                                    events: secondGroup.map(context.makeExpectedEventViewModel))
        ]
        
        XCTAssertEqual(expected, delegate.eventsViewModels)
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
        
        let allEvents = firstGroup + secondGroup
        let eventsService = CapturingEventsService()
        
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        eventsService.simulateEventsChanged(allEvents)
        
        let expected = [ScheduleEventGroupViewModel(title: context.hoursFormatter.hoursString(from: firstGroupDate),
                                                    events: firstGroup.map(context.makeExpectedEventViewModel)),
                        ScheduleEventGroupViewModel(title: context.hoursFormatter.hoursString(from: secondGroupDate),
                                                    events: secondGroup.map(context.makeExpectedEventViewModel))
        ]
        
        XCTAssertEqual(expected, delegate.eventsViewModels)
    }
    
    func testAdaptDaysIntoViewModelsWithFriendlyDateTitles() {
        let days = [Day].random
        let eventsService = StubEventsService()
        eventsService.allDays = days
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        
        let expected = days.map(context.makeExpectedDayViewModel)
        
        XCTAssertEqual(expected, delegate.daysViewModels)
    }
    
    func testInformDelegateAboutLaterDayChanges() {
        let days = [Day].random
        let eventsService = CapturingEventsService()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        eventsService.simulateDaysChanged(days)
        
        let expected = days.map(context.makeExpectedDayViewModel)
        
        XCTAssertEqual(expected, delegate.daysViewModels)
    }
    
    func testProvideCurrentDayIndex() {
        let days = [Day].random.sorted()
        let currentDay = days.randomElement()
        let eventsService = StubEventsService()
        eventsService.allDays = days
        eventsService.currentDay = currentDay.element
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        
        XCTAssertEqual(currentDay.index, delegate.currentDayIndex)
    }
    
    func testProvideZeroIndexWhenCurrentDayIsNotAvailable() {
        let context = ScheduleInteractorTestBuilder().build()
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        
        XCTAssertEqual(0, delegate.currentDayIndex)
    }
    
}
