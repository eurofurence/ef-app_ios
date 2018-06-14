//
//  DefaultScheduleInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DefaultScheduleInteractor: ScheduleInteractor, EventsServiceObserver {

    // MARK: Nested Types

    private struct EventsGroupedByDate: Comparable {
        static func < (lhs: EventsGroupedByDate, rhs: EventsGroupedByDate) -> Bool {
            return lhs.date < rhs.date
        }

        var date: Date
        var events: [Event2]
    }

    // MARK: Properties

    private let hoursDateFormatter: HoursDateFormatter
    private let shortFormDateFormatter: ShortFormDateFormatter
    private let viewModel = ViewModel()

    // MARK: Initialization

    convenience init() {
        struct DummyShortFormDateFormatter: ShortFormDateFormatter {
            func dateString(from date: Date) -> String {
                return ""
            }
        }

        self.init(eventsService: EurofurenceApplication.shared,
                  hoursDateFormatter: FoundationHoursDateFormatter.shared,
                  shortFormDateFormatter: DummyShortFormDateFormatter())
    }

    init(eventsService: EventsService,
         hoursDateFormatter: HoursDateFormatter,
         shortFormDateFormatter: ShortFormDateFormatter) {
        self.hoursDateFormatter = hoursDateFormatter
        self.shortFormDateFormatter = shortFormDateFormatter

        eventsService.add(self)
    }

    // MARK: ScheduleInteractor

    private var delegate: ScheduleInteractorDelegate?
    func setDelegate(_ delegate: ScheduleInteractorDelegate) {
        self.delegate = delegate
        delegate.scheduleInteractorDidPrepareViewModel(viewModel)
    }

    // MARK: EventsServiceObserver

    func eurofurenceApplicationDidUpdateEvents(to events: [Event2]) {
        let groupedByDate = Dictionary(grouping: events, by: { $0.startDate })
        let orderedGroups = groupedByDate.map(EventsGroupedByDate.init).sorted()
        viewModel.eventGroups = orderedGroups.map { (group) -> ScheduleEventGroupViewModel in
            let title = hoursDateFormatter.hoursString(from: group.date)
            let viewModels = group.events.map { (event) -> ScheduleEventViewModel in
                return ScheduleEventViewModel(title: event.title,
                                              startTime: hoursDateFormatter.hoursString(from: event.startDate),
                                              endTime: hoursDateFormatter.hoursString(from: event.endDate),
                                              location: event.room.name)
            }

            return ScheduleEventGroupViewModel(title: title, events: viewModels)
        }

        delegate?.scheduleInteractorDidPrepareViewModel(viewModel)
    }

    func eventsServiceDidUpdateDays(to days: [Day]) {
        viewModel.days = days.sorted().map { (day) -> ScheduleDayViewModel in
            return ScheduleDayViewModel(title: shortFormDateFormatter.dateString(from: day.date))
        }
    }

    private class ViewModel: ScheduleViewModel {

        private var delegate: ScheduleViewModelDelegate?

        var days: [ScheduleDayViewModel] = [] {
            didSet {
                delegate?.scheduleViewModelDidUpdateDays(days)
            }
        }

        var eventGroups: [ScheduleEventGroupViewModel] = []

        func setDelegate(_ delegate: ScheduleViewModelDelegate) {
            self.delegate = delegate

            delegate.scheduleViewModelDidUpdateDays(days)
            delegate.scheduleViewModelDidUpdateEvents(eventGroups)
        }

    }

    func eurofurenceApplicationDidUpdateRunningEvents(to events: [Event2]) { }
    func eurofurenceApplicationDidUpdateUpcomingEvents(to events: [Event2]) { }
    func eventsServiceDidResolveFavouriteEvents(_ identifiers: [Event2.Identifier]) { }

}
