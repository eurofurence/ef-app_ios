//
//  CurrentEventsViewModel.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import Changeset
import ReactiveSwift
import Result

class CurrentEventsViewModel {
	let RunningEvents = MutableProperty<[Event]>([])
	let RunningEventsEdits = MutableProperty<([Event], [Edit<Event>])>(([] as [Event], [] as [Edit<Event>]))
	let UpcomingEvents = MutableProperty<[Event]>([])
	let UpcomingEventsEdits = MutableProperty<([Event], [Edit<Event>])>(([] as [Event], [] as [Edit<Event>]))

	private let dataContext: DataContextProtocol
	private let timeService: TimeService = try! ServiceResolver.container.resolve()
	private var timedEventsSignal: Signal<(Date, [Event]), NoError>
	private var disposable = CompositeDisposable()
	private let scheduler = QueueScheduler(qos: .background, name: "org.eurofurence.app.CurrentEventsViewModelScheduler")
	private let filterFavorites: CurrentEventsFilterFavoritesProviding = UserDetailsNewsPreferences(userDefaults: UserDefaults.standard)

	init(dataContext: DataContextProtocol) {
		self.dataContext = dataContext

		timedEventsSignal = Signal.combineLatest(timeService.currentTime.signal, dataContext.Events.signal).observe(on: scheduler)

		RunningEvents.swap(filterRunningEvents(timeService.currentTime.value, dataContext.Events.value))
		UpcomingEvents.swap(filterUpcomingEvents(timeService.currentTime.value, dataContext.Events.value))
		RunningEventsEdits.swap(([] as [Event], Changeset.edits(from: [], to: RunningEvents.value)))
		UpcomingEventsEdits.swap(([] as [Event], Changeset.edits(from: [], to: UpcomingEvents.value)))

		disposable += RunningEvents <~ timedEventsSignal.map(filterRunningEvents)
			.skipRepeats({ $0.count == $1.count && $0.starts(with: $1)})

		disposable += RunningEventsEdits <~ RunningEvents.combinePrevious(RunningEvents.value)
			.map({ (oldEvents, newEvents) in
				return (newEvents, Changeset.edits(from: oldEvents, to: newEvents))
			})

		disposable += UpcomingEvents <~ timedEventsSignal.map(filterUpcomingEvents)
			.skipRepeats({ $0.count == $1.count && $0.starts(with: $1)})

		disposable += UpcomingEventsEdits <~ UpcomingEvents.combinePrevious(UpcomingEvents.value)
			.map({ (oldEvents, newEvents) in
				return (newEvents, Changeset.edits(from: oldEvents, to: newEvents))
			})
	}

	private func filterRunningEvents(_ time: Date, _ events: [Event]) -> [Event] {
		return events.filter({ $0.StartDateTimeUtc < time && $0.EndDateTimeUtc > time &&
			(!self.filterFavorites.doFilterEventFavorites || $0.EventFavorite?.IsFavorite.value ?? false) })
	}

	private func filterUpcomingEvents(_ time: Date, _ events: [Event]) -> [Event] {
		let filteredEvents = events.filter({ $0.StartDateTimeUtc > time &&
			(!self.filterFavorites.doFilterEventFavorites || $0.EventFavorite?.IsFavorite.value ?? false) })
		return Array(filteredEvents[0..<min(10, filteredEvents.count)])
	}

	deinit {
		disposable.dispose()
	}
}
