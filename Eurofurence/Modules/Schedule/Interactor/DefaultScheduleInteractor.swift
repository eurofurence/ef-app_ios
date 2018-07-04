//
//  DefaultScheduleInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DefaultScheduleInteractor: ScheduleInteractor, EventsServiceObserver {

    // MARK: Properties

    private let viewModel: ViewModel
    private let searchViewModel: SearchViewModel

    // MARK: Initialization

    convenience init() {
        self.init(eventsService: EurofurenceApplication.shared,
                  hoursDateFormatter: FoundationHoursDateFormatter.shared,
                  shortFormDateFormatter: FoundationShortFormDateFormatter.shared,
                  shortFormDayAndTimeFormatter: FoundationShortFormDayAndTimeFormatter.shared,
                  refreshService: EurofurenceApplication.shared)
    }

    init(eventsService: EventsService,
         hoursDateFormatter: HoursDateFormatter,
         shortFormDateFormatter: ShortFormDateFormatter,
         shortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter,
         refreshService: RefreshService) {
        let schedule = eventsService.makeEventsSchedule()
        let searchController = eventsService.makeEventsSearchController()
        viewModel = ViewModel(schedule: schedule,
                              hoursDateFormatter: hoursDateFormatter,
                              shortFormDateFormatter: shortFormDateFormatter,
                              refreshService: refreshService)
        searchViewModel = SearchViewModel(searchController: searchController,
                                          shortFormDayAndTimeFormatter: shortFormDayAndTimeFormatter,
                                          hoursDateFormatter: hoursDateFormatter)

        eventsService.add(self)
    }

    // MARK: ScheduleInteractor

    func makeViewModel(completionHandler: @escaping (ScheduleViewModel) -> Void) {
        completionHandler(viewModel)
    }

    func makeSearchViewModel(completionHandler: @escaping (ScheduleSearchViewModel) -> Void) {
        completionHandler(searchViewModel)
    }

    // MARK: EventsServiceObserver

    func eventsDidChange(to events: [Event2]) {
        viewModel.scheduleEventsDidChange(to: events)
    }

    func favouriteEventsDidChange(_ identifiers: [Event2.Identifier]) {
        viewModel.favouriteEventsDidChange(identifiers)
        searchViewModel.favouriteEventsDidChange(identifiers)
    }

    func runningEventsDidChange(to events: [Event2]) {}
    func upcomingEventsDidChange(to events: [Event2]) {}

    // MARK: Private

    private class ViewModel: ScheduleViewModel, EventsScheduleDelegate, RefreshServiceObserver {

        private struct EventsGroupedByDate: Comparable {
            static func < (lhs: EventsGroupedByDate, rhs: EventsGroupedByDate) -> Bool {
                return lhs.date < rhs.date
            }

            var date: Date
            var events: [Event2]
        }

        private var delegate: ScheduleViewModelDelegate?
        private var rawModelGroups = [EventsGroupedByDate]()

        private var days = [Day]()
        var dayViewModels: [ScheduleDayViewModel] = [] {
            didSet {
                delegate?.scheduleViewModelDidUpdateDays(dayViewModels)
            }
        }

        var eventGroupViewModels: [ScheduleEventGroupViewModel] = [] {
            didSet {
                delegate?.scheduleViewModelDidUpdateEvents(eventGroupViewModels)
            }
        }

        private let schedule: EventsSchedule
        private let hoursDateFormatter: HoursDateFormatter
        private let shortFormDateFormatter: ShortFormDateFormatter
        private let refreshService: RefreshService
        private var events = [Event2]()
        private var favouriteEvents = [Event2.Identifier]()

        init(schedule: EventsSchedule,
             hoursDateFormatter: HoursDateFormatter,
             shortFormDateFormatter: ShortFormDateFormatter,
             refreshService: RefreshService) {
            self.schedule = schedule
            self.hoursDateFormatter = hoursDateFormatter
            self.shortFormDateFormatter = shortFormDateFormatter
            self.refreshService = refreshService

            refreshService.add(self)
            schedule.setDelegate(self)
        }

        var selectedDayIndex = 0

        fileprivate func regenerateEventViewModels() {
            let groupedByDate = Dictionary(grouping: events, by: { $0.startDate })
            rawModelGroups = groupedByDate.map(EventsGroupedByDate.init).sorted()
            eventGroupViewModels = rawModelGroups.map { (group) -> ScheduleEventGroupViewModel in
                let title = hoursDateFormatter.hoursString(from: group.date)
                let viewModels = group.events.map { (event) -> ScheduleEventViewModel in
                    return ScheduleEventViewModel(title: event.title,
                                                  startTime: hoursDateFormatter.hoursString(from: event.startDate),
                                                  endTime: hoursDateFormatter.hoursString(from: event.endDate),
                                                  location: event.room.name,
                                                  isFavourite: favouriteEvents.contains(event.identifier))
                }

                return ScheduleEventGroupViewModel(title: title, events: viewModels)
            }
        }

        func scheduleEventsDidChange(to events: [Event2]) {
            self.events = events
            regenerateEventViewModels()
        }

        func eventDaysDidChange(to days: [Day]) {
            self.days = days
            self.dayViewModels = days.map { (day) -> ScheduleDayViewModel in
                return ScheduleDayViewModel(title: shortFormDateFormatter.dateString(from: day.date))
            }
        }

        func currentEventDayDidChange(to day: Day?) {
            guard let day = day else { return }
            schedule.restrictEvents(to: day)

            guard let idx = days.index(where: { $0.date == day.date }) else { return }
            selectedDayIndex = idx
        }

        func setDelegate(_ delegate: ScheduleViewModelDelegate) {
            self.delegate = delegate

            delegate.scheduleViewModelDidUpdateDays(dayViewModels)
            delegate.scheduleViewModelDidUpdateEvents(eventGroupViewModels)
            delegate.scheduleViewModelDidUpdateCurrentDayIndex(to: selectedDayIndex)
        }

        func refresh() {
            refreshService.refreshLocalStore { (_) in }
        }

        func showEventsForDay(at index: Int) {
            let day = days[index]
            schedule.restrictEvents(to: day)
        }

        func identifierForEvent(at indexPath: IndexPath) -> Event2.Identifier? {
            return rawModelGroups[indexPath.section].events[indexPath.row].identifier
        }

        func refreshServiceDidBeginRefreshing() {
            delegate?.scheduleViewModelDidBeginRefreshing()
        }

        func refreshServiceDidFinishRefreshing() {
            delegate?.scheduleViewModelDidFinishRefreshing()
        }

        func favouriteEventsDidChange(_ identifiers: [Event2.Identifier]) {
            favouriteEvents = identifiers
            regenerateEventViewModels()
        }

    }

    private class SearchViewModel: ScheduleSearchViewModel, EventsSearchControllerDelegate {

        private struct EventsGroupedByDate: Comparable {
            static func < (lhs: EventsGroupedByDate, rhs: EventsGroupedByDate) -> Bool {
                return lhs.date < rhs.date
            }

            var date: Date
            var events: [Event2]
        }

        private let searchController: EventsSearchController
        private let shortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter
        private let hoursDateFormatter: HoursDateFormatter
        private var rawModelGroups = [EventsGroupedByDate]()
        private var searchResults = [Event2]()
        private var favouriteEvents = [Event2.Identifier]()

        init(searchController: EventsSearchController,
             shortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter,
             hoursDateFormatter: HoursDateFormatter) {
            self.searchController = searchController
            self.hoursDateFormatter = hoursDateFormatter
            self.shortFormDayAndTimeFormatter = shortFormDayAndTimeFormatter

            searchController.setResultsDelegate(self)
        }

        private var delegate: ScheduleSearchViewModelDelegate?
        func setDelegate(_ delegate: ScheduleSearchViewModelDelegate) {
            self.delegate = delegate
        }

        func updateSearchResults(input: String) {
            searchController.changeSearchTerm(input)
        }

        func identifierForEvent(at indexPath: IndexPath) -> Event2.Identifier? {
            return rawModelGroups[indexPath.section].events[indexPath.row].identifier
        }

        func searchResultsDidUpdate(to results: [Event2]) {
            searchResults = results
            regenerateViewModel()
        }

        func favouriteEventsDidChange(_ identifiers: [Event2.Identifier]) {
            favouriteEvents = identifiers
            regenerateViewModel()
        }

        private func regenerateViewModel() {
            let groupedByDate = Dictionary(grouping: searchResults, by: { $0.startDate })
            rawModelGroups = groupedByDate.map(EventsGroupedByDate.init).sorted()
            let eventGroupViewModels = rawModelGroups.map { (group) -> ScheduleEventGroupViewModel in
                let title = shortFormDayAndTimeFormatter.dayAndHoursString(from: group.date)
                let viewModels = group.events.map { (event) -> ScheduleEventViewModel in
                    return ScheduleEventViewModel(title: event.title,
                                                  startTime: hoursDateFormatter.hoursString(from: event.startDate),
                                                  endTime: hoursDateFormatter.hoursString(from: event.endDate),
                                                  location: event.room.name,
                                                  isFavourite: favouriteEvents.contains(event.identifier))
                }

                return ScheduleEventGroupViewModel(title: title, events: viewModels)
            }

            delegate?.scheduleSearchResultsUpdated(eventGroupViewModels)
        }

    }

}
