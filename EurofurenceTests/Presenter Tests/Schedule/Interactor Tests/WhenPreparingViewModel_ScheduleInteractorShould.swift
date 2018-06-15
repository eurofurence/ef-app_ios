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
    
    func testAdaptDaysIntoViewModelsWithFriendlyDateTitles() {
        let days = [Day].random
        eventsService.simulateDaysChanged(days)
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        
        let expected = days.map(context.makeExpectedDayViewModel)
        
        XCTAssertEqual(expected, delegate.daysViewModels)
    }
    
    func testInformDelegateAboutLaterDayChanges() {
        let days = [Day].random
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
