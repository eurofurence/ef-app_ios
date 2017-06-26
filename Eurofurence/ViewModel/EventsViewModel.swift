//
//  EventsViewModel.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Changeset

class EventsViewModel {
	let Events = MutableProperty<[Event]>([])
	let EventsEdits = MutableProperty<[Edit<Event>]>([])
	let EventConferenceDays = MutableProperty<[EventConferenceDay]>([])
	let EventConferenceRooms = MutableProperty<[EventConferenceRoom]>([])
	let EventConferenceTracks = MutableProperty<[EventConferenceTrack]>([])
	private let dataContext: IDataContext
	private let timeService: TimeService = try! ServiceResolver.container.resolve()
	private var timedEventsSignal: Signal<(Date, [Event]), NoError>
	
	init(dataContext: IDataContext) {
		self.dataContext = dataContext
		timedEventsSignal = Signal.combineLatest(timeService.currentTime.signal, dataContext.Events.signal).observe(on: QueueScheduler.main)
		
		Events <~ dataContext.Events
		
		EventsEdits <~ Events.combinePrevious([] as [Event]).map { (old, new) -> [Edit<Event>] in
			return Changeset.edits(from: old, to: new)
		}
		
		EventConferenceDays <~ dataContext.EventConferenceDays
		
		EventConferenceRooms <~ dataContext.EventConferenceRooms
		
		EventConferenceTracks <~ dataContext.EventConferenceTracks
	}
}
