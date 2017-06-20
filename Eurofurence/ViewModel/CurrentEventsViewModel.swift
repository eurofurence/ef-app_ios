//
//  CurrentEventsViewModel.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-06-17.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
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

		RunningEvents <~ timedEventsSignal.map { (time, events) -> [Event] in
			return events.filter({ $0.StartDateTimeUtc < time && $0.EndDateTimeUtc > time })
		}

		RunningEventsEdits <~ RunningEvents.combinePrevious([] as [Event]).map { (eventsOld, eventsNew) -> [Edit<Event>] in
			return Changeset.edits(from: eventsOld, to: eventsNew)
		}

		UpcomingEvents <~ timedEventsSignal.map({ (time, events) in
			return Array(events.filter({ $0.StartDateTimeUtc > time })[0..<10])
		})

		UpcomingEventsEdits <~ UpcomingEvents.combinePrevious([] as [Event]).map { (eventsOld, eventsNew) -> [Edit<Event>] in
			return Changeset.edits(from: eventsOld, to: eventsNew)
		}
	}
}