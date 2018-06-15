//
//  ScheduleInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class ScheduleInteractorTestBuilder {
    
    struct Context {
        var interactor: DefaultScheduleInteractor
        var hoursFormatter: FakeHoursDateFormatter
        var shortFormDateFormatter: FakeShortFormDateFormatter
        let viewModelDelegate = CapturingScheduleViewModelDelegate()
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
    
    var eventsViewModels: [ScheduleEventGroupViewModel] {
        return viewModelDelegate.eventsViewModels
    }
    
    var daysViewModels: [ScheduleDayViewModel] {
        return viewModelDelegate.daysViewModels
    }
    
    var currentDayIndex: Int? {
        return viewModelDelegate.currentDayIndex
    }
    
    @discardableResult
    func makeViewModel() -> ScheduleViewModel? {
        var viewModel: ScheduleViewModel?
        interactor.makeViewModel { (vm) in
            viewModel = vm
            vm.setDelegate(self.viewModelDelegate)
        }
        
        return viewModel
    }
    
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
