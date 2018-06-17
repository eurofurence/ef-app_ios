//
//  DefaultScheduleInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DefaultScheduleInteractor: ScheduleInteractor {

    // MARK: Properties

    private let viewModel: ViewModel

    // MARK: Initialization

    convenience init() {
        self.init(eventsService: EurofurenceApplication.shared,
                  hoursDateFormatter: FoundationHoursDateFormatter.shared,
                  shortFormDateFormatter: FoundationShortFormDateFormatter.shared)
    }

    init(eventsService: EventsService,
         hoursDateFormatter: HoursDateFormatter,
         shortFormDateFormatter: ShortFormDateFormatter) {
        let schedule = eventsService.makeEventsSchedule()
        viewModel = ViewModel(schedule: schedule,
                              hoursDateFormatter: hoursDateFormatter,
                              shortFormDateFormatter: shortFormDateFormatter)
        eventsService.add(viewModel)
    }

    // MARK: ScheduleInteractor

    func makeViewModel(completionHandler: @escaping (ScheduleViewModel) -> Void) {
        completionHandler(viewModel)
    }

    func makeSearchViewModel(completionHandler: @escaping (ScheduleSearchViewModel) -> Void) {

    }

    private class ViewModel: ScheduleViewModel, EventsServiceObserver, EventsScheduleDelegate {

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

        init(schedule: EventsSchedule,
             hoursDateFormatter: HoursDateFormatter,
             shortFormDateFormatter: ShortFormDateFormatter) {
            self.schedule = schedule
            self.hoursDateFormatter = hoursDateFormatter
            self.shortFormDateFormatter = shortFormDateFormatter

            schedule.setDelegate(self)
        }

        var selectedDayIndex = 0

        func eventsDidChange(to events: [Event2]) {
            let groupedByDate = Dictionary(grouping: events, by: { $0.startDate })
            rawModelGroups = groupedByDate.map(EventsGroupedByDate.init).sorted()
            eventGroupViewModels = rawModelGroups.map { (group) -> ScheduleEventGroupViewModel in
                let title = hoursDateFormatter.hoursString(from: group.date)
                let viewModels = group.events.map { (event) -> ScheduleEventViewModel in
                    return ScheduleEventViewModel(title: event.title,
                                                  startTime: hoursDateFormatter.hoursString(from: event.startDate),
                                                  endTime: hoursDateFormatter.hoursString(from: event.endDate),
                                                  location: event.room.name)
                }

                return ScheduleEventGroupViewModel(title: title, events: viewModels)
            }
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

        func showEventsForDay(at index: Int) {
            let day = days[index]
            schedule.restrictEvents(to: day)
        }

        func identifierForEvent(at indexPath: IndexPath) -> Event2.Identifier? {
            return rawModelGroups[indexPath.section].events[indexPath.row].identifier
        }

        func runningEventsDidChange(to events: [Event2]) { }
        func upcomingEventsDidChange(to events: [Event2]) { }
        func favouriteEventsDidChange(_ identifiers: [Event2.Identifier]) { }

    }

}
