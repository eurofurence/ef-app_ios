//
//  ScheduleInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation

class FakeShortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter {
    
    private var strings = [Date : String]()
    
    func dayAndHoursString(from date: Date) -> String {
        var output = String.random
        if let previous = strings[date] {
            output = previous
        }
        else {
            strings[date] = output
        }
        
        return output
    }
    
}

class ScheduleInteractorTestBuilder {
    
    struct Context {
        var interactor: DefaultScheduleInteractor
        var eventsService: FakeEventsService
        var hoursFormatter: FakeHoursDateFormatter
        var shortFormDateFormatter: FakeShortFormDateFormatter
        var shortFormDayAndTimeFormatter: FakeShortFormDayAndTimeFormatter
        let viewModelDelegate = CapturingScheduleViewModelDelegate()
        let searchViewModelDelegate = CapturingScheduleSearchViewModelDelegate()
        var refreshService: CapturingRefreshService
    }
    
    private var eventsService: FakeEventsService
    
    init() {
        eventsService = FakeEventsService()
    }
    
    @discardableResult
    func with(_ eventsService: FakeEventsService) -> ScheduleInteractorTestBuilder {
        self.eventsService = eventsService
        return self
    }
    
    func build() -> Context {
        let hoursFormatter = FakeHoursDateFormatter()
        let shortFormDateFormatter = FakeShortFormDateFormatter()
        let shortFormDayAndTimeFormatter = FakeShortFormDayAndTimeFormatter()
        let refreshService = CapturingRefreshService()
        let interactor = DefaultScheduleInteractor(eventsService: eventsService,
                                                   hoursDateFormatter: hoursFormatter,
                                                   shortFormDateFormatter: shortFormDateFormatter,
                                                   shortFormDayAndTimeFormatter: shortFormDayAndTimeFormatter,
                                                   refreshService: refreshService)
        
        return Context(interactor: interactor,
                       eventsService: eventsService,
                       hoursFormatter: hoursFormatter,
                       shortFormDateFormatter: shortFormDateFormatter,
                       shortFormDayAndTimeFormatter: shortFormDayAndTimeFormatter,
                       refreshService: refreshService)
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
    
    @discardableResult
    func makeSearchViewModel() -> ScheduleSearchViewModel? {
        var searchViewModel: ScheduleSearchViewModel?
        interactor.makeSearchViewModel { (viewModel) in
            searchViewModel = viewModel
            viewModel.setDelegate(self.searchViewModelDelegate)
        }
        
        return searchViewModel
    }
    
    func makeExpectedEventViewModel(from event: Event2) -> ScheduleEventViewModel {
        return ScheduleEventViewModel(title: event.title,
                                      startTime: hoursFormatter.hoursString(from: event.startDate),
                                      endTime: hoursFormatter.hoursString(from: event.endDate),
                                      location: event.room.name,
                                      bannerGraphicPNGData: event.bannerGraphicPNGData,
                                      isFavourite: eventsService.favourites.contains(event.identifier),
                                      isSponsorOnly: event.isSponsorOnly,
                                      isSuperSponsorOnly: event.isSuperSponsorOnly,
                                      isArtShow: event.isArtShow,
                                      isKageEvent: event.isKageEvent,
                                      isDealersDenEvent: event.isDealersDen,
                                      isMainStageEvent: event.isMainStage,
                                      isPhotoshootEvent: event.isPhotoshoot)
    }
    
    func makeExpectedDayViewModel(from day: Day) -> ScheduleDayViewModel {
        return ScheduleDayViewModel(title: shortFormDateFormatter.dateString(from: day.date))
    }
    
}
