//
//  CurrentEventsViewModel.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Changeset

class CurrentEventsViewModel {
	let RunningEvents = MutableProperty<[Event]>([])
	let UpcomingEvents = MutableProperty<[Event]>([])
	let RunningEventsEdits = MutableProperty<[Edit<Event>]>([])
	let UpcomingEventsEdits = MutableProperty<[Edit<Event>]>([])
	private let dataContext: IDataContext
	private let timeService: TimeService = try! ServiceResolver.container.resolve()
	private var timedEventsSignal: Signal<(Date, [Event]), NoError>
	private var disposable = CompositeDisposable()

	init(dataContext: IDataContext) {
		self.dataContext = dataContext
		timedEventsSignal = Signal.combineLatest(timeService.currentTime.signal, dataContext.Events.signal).observe(on: QueueScheduler.main)

		disposable += RunningEvents <~ timedEventsSignal.map { (time, items) -> [Event] in
			return items.filter({ $0.StartDateTimeUtc < time && $0.EndDateTimeUtc > time })
		}

		disposable += UpcomingEvents <~ timedEventsSignal.map({ (time, items) in
			let filteredItems = items.filter({ $0.StartDateTimeUtc > time })
			return Array(filteredItems[0..<min(10, filteredItems.count)])
		})
	}
	
	deinit {
		disposable.dispose()
	}
}
