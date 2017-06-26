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

	init(dataContext: IDataContext) {
		self.dataContext = dataContext
		timedEventsSignal = Signal.combineLatest(timeService.currentTime.signal, dataContext.Events.signal).observe(on: QueueScheduler.main)

		RunningEvents <~ timedEventsSignal.map { (time, items) -> [Event] in
			return items.filter({ $0.StartDateTimeUtc < time && $0.EndDateTimeUtc > time })
		}

		RunningEventsEdits <~ RunningEvents.combinePrevious([] as [Event]).map { (old, new) -> [Edit<Event>] in
			return Changeset.edits(from: old, to: new)
		}

		UpcomingEvents <~ timedEventsSignal.map({ (time, items) in
			return Array(items.filter({ $0.StartDateTimeUtc > time })[0..<10])
		})

		UpcomingEventsEdits <~ UpcomingEvents.combinePrevious([] as [Event]).map { (old, new) -> [Edit<Event>] in
			return Changeset.edits(from: old, to: new)
		}
	}
}
