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
    private var viewModel: ScheduleViewModel?

    // MARK: Initialization

    convenience init() {
        self.init(eventsService: EurofurenceApplication.shared,
                  hoursDateFormatter: FoundationHoursDateFormatter.shared)
    }

    init(eventsService: EventsService,
         hoursDateFormatter: HoursDateFormatter) {
        self.hoursDateFormatter = hoursDateFormatter

        eventsService.add(self)
    }

    // MARK: ScheduleInteractor

    private var delegate: ScheduleInteractorDelegate?
    func setDelegate(_ delegate: ScheduleInteractorDelegate) {
        self.delegate = delegate

        if let viewModel = viewModel {
            delegate.scheduleInteractorDidPrepareViewModel(viewModel)
        }
    }

    // MARK: EventsServiceObserver

    func eurofurenceApplicationDidUpdateEvents(to events: [Event2]) {
        let groupedByDate = Dictionary(grouping: events, by: { $0.startDate })
        let orderedGroups = groupedByDate.map(EventsGroupedByDate.init).sorted()
        let groupViewModels = orderedGroups.map { (group) -> ScheduleEventGroupViewModel in
            let title = hoursDateFormatter.hoursString(from: group.date)
            let viewModels = group.events.map { (event) -> ScheduleEventViewModel in
                return ScheduleEventViewModel(title: event.title,
                                              startTime: hoursDateFormatter.hoursString(from: event.startDate),
                                              endTime: hoursDateFormatter.hoursString(from: event.endDate),
                                              location: event.room.name)
            }

            return ScheduleEventGroupViewModel(title: title, events: viewModels)
        }

        let viewModel = ViewModel(days: [], eventGroups: groupViewModels)
        self.viewModel = viewModel
        delegate?.scheduleInteractorDidPrepareViewModel(viewModel)
    }

    private struct ViewModel: ScheduleViewModel {

        var days: [ScheduleDayViewModel]
        var eventGroups: [ScheduleEventGroupViewModel]

        func setDelegate(_ delegate: ScheduleViewModelDelegate) {
            delegate.scheduleViewModelDidUpdateDays(days)
            delegate.scheduleViewModelDidUpdateEvents(eventGroups)
        }

    }

    func eurofurenceApplicationDidUpdateRunningEvents(to events: [Event2]) { }

    func eurofurenceApplicationDidUpdateUpcomingEvents(to events: [Event2]) { }

    func eventsServiceDidResolveFavouriteEvents(_ identifiers: [Event2.Identifier]) { }

}
