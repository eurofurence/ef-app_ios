//
//  CurrentEventsViewModel.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class CurrentEventsViewModel {
	let RunningEvents = MutableProperty<[Event]>([])
	let UpcomingEvents = MutableProperty<[Event]>([])
	private let dataContext: DataContextProtocol
	private let timeService: TimeService = try! ServiceResolver.container.resolve()
	private var timedEventsSignal: Signal<(Date, [Event]), NoError>
	private var disposable = CompositeDisposable()
	private let scheduler = QueueScheduler(qos: .background, name: "org.eurofurence.app.CurrentEventsViewModelScheduler")

	init(dataContext: DataContextProtocol) {
		self.dataContext = dataContext

		RunningEvents.swap(CurrentEventsViewModel.filterRunningEvents(timeService.currentTime.value, dataContext.Events.value))
		UpcomingEvents.swap(CurrentEventsViewModel.filterUpcomingEvents(timeService.currentTime.value, dataContext.Events.value))

		timedEventsSignal = Signal.combineLatest(timeService.currentTime.signal, dataContext.Events.signal).observe(on: scheduler)

		disposable += RunningEvents <~ timedEventsSignal.map { (time, items) -> [Event] in
			return items.filter({ $0.StartDateTimeUtc < time && $0.EndDateTimeUtc > time })
		}

		disposable += UpcomingEvents <~ timedEventsSignal.map({ (time, items) in
			let filteredItems = items.filter({ $0.StartDateTimeUtc > time })
			return Array(filteredItems[0..<min(10, filteredItems.count)])
		})
	}

	static private func filterRunningEvents(_ time: Date, _ events: [Event]) -> [Event] {
		return events.filter({ $0.StartDateTimeUtc < time && $0.EndDateTimeUtc > time })
	}

	static private func filterUpcomingEvents(_ time: Date, _ events: [Event]) -> [Event] {
		let filteredEvents = events.filter({ $0.StartDateTimeUtc > time })
		return Array(filteredEvents[0..<min(10, filteredEvents.count)])
	}

	deinit {
		disposable.dispose()
	}
}
